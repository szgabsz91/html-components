library paginator;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "dart:math" as math;

part "paginator/model.dart";

class PaginatorComponent extends WebComponent {
  PaginatorModel model = new PaginatorModel();
  
  SelectElement get _select => this.query("select");
  
  static const EventStreamProvider<CustomEvent> _PAGE_CHANGED_EVENT = const EventStreamProvider<CustomEvent>("pageChanged");
  Stream<CustomEvent> get onPageChanged => _PAGE_CHANGED_EVENT.forTarget(this);
  static void _dispatchPageChangedEvent(Element element, int currentPage) {
    element.dispatchEvent(new CustomEvent("pageChanged", detail: currentPage));
  }
  
  String get position => model.position;
  set position(String position) => model.position = position;
  
  int get currentpage => model.currentPage;
  set currentpage(int currentpage) => model.currentPage = currentpage;
  
  int get rows => model.rows;
  set rows(int rows) {
    if (rows == model.rows) {
      return;
    }
    
    model.rows = rows;
    
    new Future.delayed(new Duration(milliseconds: 100), () {
      _select.value = model.rows.toString();
    });
  }
  
  List<int> get rowsperpage => model.rowsPerPage;
  set rowsperpage(List<int> rowsperpage) => model.rowsPerPage = rowsperpage;
  
  void navigateToFirstPage() {
    model.currentPage = 1;
  }
  
  void navigateToPreviousPage() {
    if (model.currentPage == 1) {
      return;
    }
    
    model.currentPage--;
  }
  
  void navigateToNextPage() {
    if (model.currentPage == model.totalPages) {
      return;
    }
    
    model.currentPage++;
  }
  
  void navigateToLastPage() {
    model.currentPage = model.totalPages;
  }
  
  void _onMouseOverPageLink(MouseEvent event, int page) {
    if (page == model.currentPage) {
      return;
    }
    
    SpanElement target = event.target;
    target.classes.add("x-paginator_ui-state-hover");
  }
  
  void _onMouseOutPageLink(MouseEvent event, int page) {
    if (page == model.currentPage) {
      return;
    }
    
    SpanElement target = event.target;
    target.classes.remove("x-paginator_ui-state-hover");
  }
  
  void _onPageLinkClicked(MouseEvent event, int page) {
    event.preventDefault();
    
    if (page == model.currentPage) {
      return;
    }
    
    model.currentPage = page;
  }
  
  void _onMouseOverNavigator(MouseEvent event) {
    SpanElement target = event.currentTarget;
    
    if (target.classes.contains("x-paginator_ui-state-disabled")) {
      return;
    }
    
    target.classes.add("x-paginator_ui-state-hover");
  }
  
  void _onMouseOutNavigator(MouseEvent event) {
    SpanElement target = event.currentTarget;
    target.classes.remove("x-paginator_ui-state-hover");
  }
  
  void _onFirstPageButtonClicked(MouseEvent event) {
    SpanElement target = event.currentTarget;
    target.classes.remove("x-paginator_ui-state-hover");
    navigateToFirstPage();
  }
  
  void _onPreviousPageButtonClicked(MouseEvent event) {
    SpanElement target = event.currentTarget;
    target.classes.remove("x-paginator_ui-state-hover");
    navigateToPreviousPage();
  }
  
  void _onNextPageButtonClicked(MouseEvent event) {
    SpanElement target = event.currentTarget;
    target.classes.remove("x-paginator_ui-state-hover");
    navigateToNextPage();
  }
  
  void _onLastPageButtonClicked(MouseEvent event) {
    SpanElement target = event.currentTarget;
    target.classes.remove("x-paginator_ui-state-hover");
    navigateToLastPage();
  }
  
  void _onSelectFocused(Event event) {
    SelectElement target = event.target;
    target.classes.add("x-paginator_ui-state-hover");
  }
  
  void _onSelectBlurred(Event event) {
    SelectElement target = event.target;
    
    if (event.type != "blur" && target.attributes.containsKey("data-focused")) {
      return;
    }
    
    target.classes.remove("x-paginator_ui-state-hover");
    target.attributes.remove("data-focused");
  }
  
  void _onSelectClicked(MouseEvent event) {
    SelectElement target = event.target;
    
    if (target.attributes.containsKey("data-focused")) {
      target.attributes.remove("data-focused");
    }
    else {
      target.attributes["data-focused"] = "true";
    }
  }
  
  void _onSelectChanged(Event event) {
    SelectElement select = event.target;
    model.rows = int.parse(select.value);
  }
  
  Iterable<int> _getVisiblePageLinks() {
    int visiblePageLinks = math.min(model.maxPageLinks, model.totalPages);
    
    int correction = math.max(1, model.currentPage - (visiblePageLinks / 2).floor());
    
    if (correction + visiblePageLinks - 1 > model.totalPages) {
      correction -= (correction + visiblePageLinks - 1 - model.totalPages);
    }
    
    return new Iterable.generate(visiblePageLinks, (int i) => i + correction);
  }
}