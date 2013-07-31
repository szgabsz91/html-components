library datagrid;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "dart:json" as json;
import "paginator.dart";
import "../common/templates.dart";
import "../common/converters.dart" as converters;

part "datagrid/template_manager.dart";
part "datagrid/model.dart";
part "datagrid/data.dart";

class DatagridComponent extends WebComponent {
  DatagridModel model = new DatagridModel();
  
  // needed for paginator data binding
  int _currentpage = 0;
  
  DivElement get _hiddenArea => this.query(".x-datagrid_ui-helper-hidden");
  TemplateElement get _template => _hiddenArea.query("template");
  DivElement get _rootElement => this.query(".x-datagrid_ui-datagrid");
  List<SelectElement> get _paginatorSelects => this.queryAll(".x-datagrid_ui-paginator-rpp-options");
  List<DivElement> get _paginatorElements => this.queryAll('div[is="x-paginator"]');
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<Event> get onSelected => _SELECTED_EVENT.forTarget(this);
  static void _dispatchSelectedEvent(Element element, Object item) {
    element.dispatchEvent(new CustomEvent("selected", detail: item.toString()));
  }
  
  void inserted() {
    model._templateManager = new DatagridTemplateManager(_hiddenArea.innerHtml);
    _hiddenArea.remove();
    
    Timer.run(() => currentpage = 1);
  }
  
  set data(var data) {
    if (data is List) {
      model._dataFetcher = new DatagridClientDataFetcher(data);
    }
    else if (data is String) {
      Uri serviceURL = Uri.parse(data);
      model._dataFetcher = new DatagridServerDataFetcher(serviceURL);
    }
    else {
      throw new ArgumentError("The data property must be of type List or String!");
    }
    
    Timer.run(() => currentpage = 1);
  }
  
  bool get selectable => model.selectable;
  set selectable(var selectable) {
    if (selectable is bool) {
      model.selectable = selectable;
    }
    else if (selectable is String) {
      model.selectable = selectable == "true";
    }
    else {
      throw new ArgumentError("The selection property must be of type bool or String!");
    }
  }
  
  int get columns => model.columns;
  set columns(var columns) {
    if (columns is int) {
      model.columns = columns;
    }
    else if (columns is String) {
      model.columns = int.parse(columns);
    }
    else {
      throw new ArgumentError("The columns property must be of type int or String!");
    }
  }
  
  int get rows => model.rows;
  set rows(var rows) {
    int rowsInt = 0;
    
    if (rows is int) {
      rowsInt = rows;
    }
    else if (rows is String) {
      rowsInt = int.parse(rows);
    }
    else {
      throw new ArgumentError("The rows property must be of type int or String!");
    }
    
    if (rowsInt == model.rows) {
      return;
    }
    
    model.rows = rowsInt;
    
    if (currentpage > model.totalPages) {
      currentpage = model.totalPages;
    }
    
    loadPage(currentpage);
    
    Timer.run(() {
      _refreshPaginators((PaginatorComponent paginator) => paginator.rows = model.rows);
    });
  }
  
  set maxpagelinks(var maxpagelinks) {
    int maxPageLinks = 0;
    
    if (maxpagelinks is int) {
      maxPageLinks = maxpagelinks;
    }
    else if (maxpagelinks is String) {
      maxPageLinks = int.parse(maxpagelinks);
    }
    else {
      throw new ArgumentError("The maxpagelinks property must be of type int or String!");
    }
    
    Timer.run(() {
      _refreshPaginators((PaginatorComponent paginator) => paginator.model.maxPageLinks = maxPageLinks);
    });
  }
  
  String get paginatorposition => model.paginatorPosition;
  set paginatorposition(String paginatorposition) => model.paginatorPosition = paginatorposition;
  
  set rowsperpagetemplate(String rowsperpagetemplate) {
    List<int> rowsperpagelist = rowsperpagetemplate
                                  .split(",")
                                  .map((String item) => int.parse(item))
                                  .toList(growable: false);
    Timer.run(() {
      _refreshPaginators((PaginatorComponent paginator) => paginator.rowsperpage = rowsperpagelist);
    });
  }

  int get currentpage => _currentpage;
  set currentpage(int currentpage) {
    _currentpage = currentpage;
    loadPage(currentpage);
  }
  
  void loadPage(int page) {
    if (model._dataFetcher != null) {
      model._dataFetcher.fetchData(page, model.rows).then((DatagridPacket result) {
        model._visibleItems = result.data;
        model.totalCount = result.totalCount;
        
        _refreshPaginators((PaginatorComponent paginator) {
          paginator.model.totalPages = model.totalPages;
        });
      }).catchError((Object error) => print("An error occured: $error"));
    }
    
    _refreshPaginators((PaginatorComponent paginator) {
      paginator.currentpage = page;
    });
  }
  
  void _onClicked(MouseEvent event, Object item) {
    Element target = event.target;
    
    if (target is SpanElement) {
      target = target.parent;
    }
    
    if (target is AnchorElement && target.classes.contains("x-datagrid_ui-commandlink")) {
      event.preventDefault();
      
      if (item is Map) {
        _dispatchSelectedEvent(this, converters.mapToString(item));
      }
      else {
        _dispatchSelectedEvent(this, item);
      }
    }
  }
  
  SafeHtml _getItemAsHtml(Object item) {
    String htmlString = model._templateManager.getSubstitutedString(item);
    return new SafeHtml.unsafe("<span>${htmlString}</span>");
  }
  
  void _refreshPaginators(void action(PaginatorComponent paginator)) {
    _paginatorElements.forEach((DivElement paginatorElement) {
      PaginatorComponent paginatorComponent = paginatorElement.xtag;
      action(paginatorComponent);
    });
  }
}