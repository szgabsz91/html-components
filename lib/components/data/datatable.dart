library datatable;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "dart:json" as json;
import "column.dart";
import "rowexpansion.dart";
import "paginator.dart";
import "common/table.dart";
import "../common/templates.dart";
import "../common/reflection.dart" as reflection;

part "datatable/cell_editor.dart";
part "datatable/filter.dart";
part "datatable/sort.dart";
part "datatable/data.dart";
part "datatable/model.dart";

class DatatableComponent extends WebComponent implements FilterListener {
  DatatableModel model = new DatatableModel();
  
  Point _mousePosition;
  ColumnResizer _columnResizer = new ColumnResizer();
  ClientCellEditor _cellEditor;
  
  // needed for paginator data binding
  int _currentpage = 0;
  
  DivElement get _hiddenArea => this.query(".x-datatable_ui-helper-hidden");
  List<DivElement> get _columnElemens => _hiddenArea.queryAll('div[is="x-column"]');
  Element get _headerElement => _hiddenArea.query("header");
  Element get _footerElement => _hiddenArea.query("footer");
  DivElement get _rowExpansionElement => _hiddenArea.query('div[is="x-rowexpansion"]');
  List<DivElement> get _paginatorElements => this.queryAll('div[is="x-paginator"]');
  InputElement get _inputElement => this.query("tbody input");
  
  static const EventStreamProvider<CustomEvent> _SORTED_EVENT = const EventStreamProvider<CustomEvent>("sorted");
  Stream<CustomEvent> get onSorted => _SORTED_EVENT.forTarget(this);
  static void _dispatchSortedEvent(Element element, String header) {
    element.dispatchEvent(new CustomEvent("sorted", detail: header));
  }
  
  static const EventStreamProvider<Event> _FILTERED_EVENT = const EventStreamProvider<Event>("filtered");
  Stream<Event> get onFiltered => _FILTERED_EVENT.forTarget(this);
  static void _dispatchFilteredEvent(Element element) {
    element.dispatchEvent(new Event("filtered"));
  }
  
  static const EventStreamProvider<Event> _SELECTED_EVENT = const EventStreamProvider<Event>("selected");
  Stream<Event> get onSelected => _SELECTED_EVENT.forTarget(this);
  static void _dispatchSelectedEvent(Element element) {
    element.dispatchEvent(new Event("selected"));
  }
  
  static const EventStreamProvider<Event> _EDITED_EVENT = const EventStreamProvider<Event>("edited");
  Stream<Event> get onEdited => _EDITED_EVENT.forTarget(this);
  static void _dispatchEditedEvent(Element element) {
    element.dispatchEvent(new Event("edited"));
  }
  
  static const EventStreamProvider<Event> _COLUMN_RESIZED_EVENT = const EventStreamProvider<Event>("columnResized");
  Stream<Event> get onColumnResized => _COLUMN_RESIZED_EVENT.forTarget(this);
  static void _dispatchColumnResizedEvent(Element element) {
    element.dispatchEvent(new Event("columnResized"));
  }
  
  static const EventStreamProvider<Event> _ROW_TOGGLED_EVENT = const EventStreamProvider<Event>("rowToggled");
  Stream<Event> get onRowToggled => _ROW_TOGGLED_EVENT.forTarget(this);
  static void _dispatchRowToggledEvent(Element element) {
    element.dispatchEvent(new Event("rowToggled"));
  }
  
  void inserted() {
    _columnElemens.forEach((DivElement columnElement) {
      ColumnComponent columnComponent = columnElement.xtag;
      ColumnModel columnModel = columnComponent.model;
      model.columns.add(columnModel);
      model.columnTemplateManagers.add(new TemplateManager(columnModel.content.toString()));
      
      if (columnModel.type == "string") {
        model._filters[columnModel] = [
          new ValueFilter(columnModel.property, FilterOperator.CONTAINS, "", this)
        ];
      }
      else if (columnModel.type == "numeric") {
        model._filters[columnModel] = [
          new ValueFilter(columnModel.property, FilterOperator.EQUALS, "", this),
          new ValueFilter(columnModel.property, FilterOperator.LESS_THAN, "", this),
          new ValueFilter(columnModel.property, FilterOperator.GREATER_THAN, "", this)
        ];
      }
      else if (columnModel.type == "boolean") {
        model._filters[columnModel] = [
          new CheckedFilter(columnModel.property, FilterOperator.EQUALS, false, this),
          new CheckedFilter(columnModel.property, FilterOperator.EQUALS, false, this)
        ];
      }
    });
    
    if (_headerElement != null) {
      model.header = _headerElement.innerHtml;
    }
    
    if (_footerElement != null) {
      model.footer = _footerElement.innerHtml;
    }
    
    if (_rowExpansionElement != null) {
      RowExpansionComponent rowExpansionComponent = _rowExpansionElement.xtag;
      RowExpansionModel rowExpansionModel = rowExpansionComponent.model;
      model.rowExpansionTemplate = new TemplateManager(rowExpansionModel.content);
    }
    
    _hiddenArea.remove();
    
    document.onMouseMove.listen(_onColumnResizing);
    document.onMouseUp.listen(_onColumnResizeStopped);
    document.onKeyDown.listen(_onKeyDown);
    document.onKeyUp.listen(_onKeyUp);
    
    Timer.run(() => currentpage = 1);
  }
  
  int get currentpage => _currentpage;
  set currentpage(int currentpage) {
    _currentpage = currentpage;
    loadPage(currentpage);
  }
  
  set data(var data) {
    if (data is List) {
      model._dataFetcher = new DatatableClientDataFetcher(data);
      _cellEditor = new ClientCellEditor();
    }
    else if (data is String) {
      Uri serviceURL = Uri.parse(data);
      model._dataFetcher = new DatatableServerDataFetcher(serviceURL);
      _cellEditor = new ServerCellEditor(serviceURL);
    }
    else {
      throw new ArgumentError("The data property must be of type List or String!");
    }
    
    Timer.run(() => currentpage = 1);
  }
  
  String get paginatorposition => model.paginatorPosition;
  set paginatorposition(String paginatorposition) => model.paginatorPosition = paginatorposition;
  
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
  
  set rowsperpagetemplate(String rowsperpagetemplate) {
    List<int> rowsperpagelist = rowsperpagetemplate
                                  .split(",")
                                  .map((String item) => int.parse(item))
                                  .toList(growable: false);
    Timer.run(() {
      _refreshPaginators((PaginatorComponent paginator) => paginator.rowsperpage = rowsperpagelist);
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
  
  String get selection => model.selection;
  set selection(String selection) => model.selection = selection;
  
  void loadPage(int page) {
    if (model._dataFetcher != null) {
      model._dataFetcher.fetchData(page, model.rows, model._sorts, model._filters).then((DatatablePacket result) {
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
  
  void _onColumnResizeStarted(MouseEvent event) {
    event.preventDefault();
    
    _mousePosition = new Point(event.page.x, event.page.y);
    SpanElement target = event.target;
    _columnResizer.resizingColumn = target.parent;
    document.body.style.cursor = "col-resize";
  }
  
  void _onColumnResizing(MouseEvent event) {
    if (_mousePosition == null || _columnResizer.resizingColumn == null) {
      return;
    }
    
    Point newPosition = new Point(event.page.x, event.page.y);
    _columnResizer.resize(newPosition.x - _mousePosition.x);
    
    _mousePosition = newPosition;
  }
  
  void _onColumnResizeStopped(MouseEvent _) {
    if (_mousePosition == null || _columnResizer.resizingColumn == null) {
      return;
    }
    
    _mousePosition = null;
    _columnResizer.resizingColumn = null;
    document.body.style.cursor = "auto";
    
    _dispatchColumnResizedEvent(this);
  }
  
  void _onKeyDown(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._multipleMode = true;
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._multipleMode = false;
    }
  }
  
  void _onMouseOverColumnHeader(MouseEvent event, ColumnModel column) {
    if (!column.sortable) {
      return;
    }
    
    Element target = event.target;
    Element targetCell = target;
    
    while (targetCell != null && targetCell is! TableCellElement) {
      targetCell = targetCell.parent;
    }
    
    if (!targetCell.classes.contains("x-datatable_ui-state-active")) {
      targetCell.classes.add("x-datatable_ui-state-hover");
    }
    else {
      targetCell.classes.remove("x-datatable_ui-state-hover");
    }
    
    if (target is! TableCellElement) {
      return;
    }
  }
  
  void _onMouseOutColumnHeader(MouseEvent event) {
    Element target = event.target;
    
    if (target is! TableCellElement) {
      return;
    }
    
    target.classes.remove("x-datatable_ui-state-hover");
    
    // Hide filter content if visible
    DivElement filterContent = target.query(".x-datatable_filter-content");
    if (filterContent != null && !filterContent.classes.contains("x-datatable_invisible")) {
      filterContent.classes.add("x-datatable_invisible");
    }
  }
  
  void _onColumnHeaderClicked(MouseEvent event, ColumnModel column) {
    Element target = event.target;
    if (target.classes.contains("x-datatable_filter-icon")) {
      return;
    }
    
    if (!column.sortable) {
      return;
    }
    
    Sort sort = _getSortByColumn(column);
    
    if (!model._multipleMode) {
      model._sorts.removeWhere((Sort currentSort) => currentSort != sort);
    }
    
    if (sort == null) {
      model._sorts.add(new Sort(column, SortDirection.ASCENDING));
    }
    else {
      if (sort.direction == SortDirection.ASCENDING) {
        sort.direction = SortDirection.DESCENDING;
      }
      else {
        model._sorts.remove(sort);
      }
    }
    
    model._dataFetcher.fetchData(currentpage, model.rows, model._sorts, model._filters).then((DatatablePacket result) {
      model._visibleItems = result.data;
      model.totalCount = result.totalCount;
      
      if ((currentpage) * model.rows > model.totalCount) {
        currentpage = (model.totalCount / model.rows).ceil();
      }
      if (currentpage == 0) {
        currentpage = 1;
      }
      
      _dispatchSortedEvent(this, column.header);
    }).catchError((Object error) => print("An error occured: $error"));
    
    new Future.delayed(new Duration(milliseconds: 50), () {
      _onMouseOverColumnHeader(event, column);
    });
  }
  
  void _onFilterIconClicked(MouseEvent event) {
    Element target = event.target;
    
    if (target is SpanElement) {
      target = target.parent;
    }
    
    if (!target.classes.contains("x-datatable_filter-icon-container")) {
      return;
    }
    
    target.query(".x-datatable_filter-content").classes.toggle("x-datatable_invisible");
  }
  
  void onFilterChanged(Filter filter) {
    new Future.delayed(new Duration(milliseconds: 100), () {
      model._dataFetcher.fetchData(currentpage, model.rows, model._sorts, model._filters).then((DatatablePacket result) {
        model._visibleItems = result.data;
        model.totalCount = result.totalCount;
        
        if ((currentpage) * model.rows > model.totalCount) {
          currentpage = (model.totalCount / model.rows).ceil();
        }
        if (currentpage == 0) {
          currentpage = 1;
        }
      }).catchError((Object error) => print("An error occured: $error"));
    });
    
    _dispatchFilteredEvent(this);
  }
  
  void _onMouseOverRow(MouseEvent event, Object item) {
    if (model.selection == "none") {
      return;
    }
    
    if (model.selectedItems.contains(item)) {
      return;
    }
    
    TableRowElement target =  event.currentTarget;
    target.classes.add("x-datatable_ui-state-hover");
  }
  
  void _onMouseOutRow(MouseEvent event, Object item) {
    if (model.selection == "none") {
      return;
    }
    
    if (model.selectedItems.contains(item)) {
      return;
    }
    
    TableRowElement target =  event.currentTarget;
    target.classes.remove("x-datatable_ui-state-hover");
  }
  
  void _onRowClicked(MouseEvent event, Object item) {
    if (model.selection == "none") {
      return;
    }
    
    event.preventDefault();
    
    if (model.selection == "multiple") {
      if (model._multipleMode) {
        if (model.selectedItems.contains(item)) {
          model.selectedItems.remove(item);
        }
        else {
          model.selectedItems.add(item);
        }
      }
      else {
        if (!model.selectedItems.contains(item)) {
          model.selectedItems.clear();
          model.selectedItems.add(item);
        }
        else {
          model.selectedItems.clear();
        }
      }
    }
    else {
      model.selectedItem = item;
    }
    
    TableRowElement target = event.currentTarget;
    target.classes.remove("x-datatable_ui-state-hover");
    
    _dispatchSelectedEvent(this);
  }
  
  void _onCellDoubleClicked(MouseEvent event, ColumnModel column, Object item) {
    if (!column.editable) {
      return;
    }
    
    event.preventDefault();
    
    _cellEditor.startEditing(column, item);
    
    new Future.delayed(new Duration(milliseconds: 50), () {
      _inputElement.focus();
    });
  }
  
  void _onEditKeyUp(KeyboardEvent event) {
    InputElement target = event.target;
    
    switch (event.which) {
      // Enter
      case 13:
        _cellEditor.acceptEditing(target.value);
        _dispatchEditedEvent(this);
        break;
      
      // Esc
      case 27:
        _cellEditor.cancelEditing();
        break;
    }
  }
  
  void _onCheckboxClicked(MouseEvent event) {
    event.preventDefault();
    CheckboxInputElement target = event.target;
    bool checked = target.checked;
    _cellEditor.acceptEditing(!checked);
  }
  
  void _onRowExpansionToggled(MouseEvent event) {
    DivElement icon = event.currentTarget;
    TableRowElement expansionRow = icon.parent.parent.nextElementSibling.nextElementSibling;
    
    if (icon.classes.contains("x-datatable_ui-icon-circle-triangle-e")) {
      icon.classes.remove("x-datatable_ui-icon-circle-triangle-e");
      icon.classes.add("x-datatable_ui-icon-circle-triangle-s");
      expansionRow.style.display = "table-row";
    }
    else {
      icon.classes.remove("x-datatable_ui-icon-circle-triangle-s");
      icon.classes.add("x-datatable_ui-icon-circle-triangle-e");
      expansionRow.style.display = "none";
    }
    
    _dispatchRowToggledEvent(this);
  }
  
  Sort _getSortByColumn(ColumnModel column) {
    return model._sorts.firstWhere((Sort sort) => sort.column == column, orElse: () => null);
  }
  
  Object _getItemProperty(Object item, String property) {
    return reflection.getPropertyValue(item, property);
  }
  
  void _refreshPaginators(void action(PaginatorComponent paginator)) {
    _paginatorElements.forEach((DivElement paginatorElement) {
      PaginatorComponent paginatorComponent = paginatorElement.xtag;
      action(paginatorComponent);
    });
  }
  
  SafeHtml _getItemAsHtml(Object item, TemplateManager templateManager) {
    String htmlString = templateManager.getSubstitutedString(item);
    return new SafeHtml.unsafe("<span>${htmlString}</span>");
  }
}