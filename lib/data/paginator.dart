import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:math' as math;

@CustomTag('h-paginator')
class PaginatorComponent extends PolymerElement {
  
  @published String position;
  @published int currentPage = 1;
  @published int totalPages = 1;
  @published int rows = 9;
  @published int maxPageLinks = 5;
  @published List<int> rowsPerPage = toObservable([3, 6, 9, 12]);
  
  @observable List<int> visiblePageLinks;
  @observable int selectedRowsPerPageIndex = 0;
  
  PaginatorComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    visiblePageLinks = toObservable(_getVisiblePageLinks().toList(growable: false));
  }
  
  void selectedRowsPerPageIndexChanged() {
    rows = int.parse($['select'].value);
  }
  
  void rowsChanged() {
    $['select'].selectedIndex = rowsPerPage.indexOf(rows);
  }
  
  void maxPageLinksChanged() {
    _refreshVisiblePageLinks();
  }
  
  void totalPagesChanged() {
    _refreshVisiblePageLinks();
  }
  
  void currentPageChanged() {
    _refreshVisiblePageLinks();
  }
  
  void _refreshVisiblePageLinks() {
    int visiblePageLinks = math.min(maxPageLinks, totalPages);
    
    int correction = math.max(1, currentPage - (visiblePageLinks / 2).floor());
    
    if (correction + visiblePageLinks - 1 > totalPages) {
      correction -= (correction + visiblePageLinks - 1 - totalPages);
    }
    
    this.visiblePageLinks = toObservable(new Iterable.generate(visiblePageLinks, (int i) => i + correction).toList(growable: false));
  }
  
  void onButtonMouseOver(MouseEvent event, var detail, Element target) {
    if (target.classes.contains('disabled') || target.classes.contains('selected')) {
      return;
    }
    
    target.classes.add('hover');
  }
  
  void onButtonMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onFirstPageButtonClicked() {
    currentPage = 1;
  }
  
  void onPreviousPageButtonClicked() {
    if (currentPage == 1) {
      return;
    }
    
    currentPage--;
  }
  
  void onPageLinkClicked(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    int page = int.parse(target.text);
    
    if (page == currentPage) {
      return;
    }
    
    currentPage = page;
  }
  
  void onNextPageButtonClicked() {
    if (currentPage == totalPages) {
      return;
    }
    
    currentPage++;
  }
  
  void onLastPageButtonClicked() {
    currentPage = totalPages;
  }
  
}