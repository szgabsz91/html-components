import 'package:polymer/polymer.dart';
import 'dart:html';
import 'datagrid/data.dart';

@CustomTag('h-datagrid')
class DatagridComponent extends PolymerElement {
  
  @published int columns = 4;
  @published int rows = 16;
  @published String paginatorPosition = 'none';
  @published String rowsPerPageTemplate = '3,6,9,12';
  @published List data;
  @published String source;
  @published int maxPageLinks = 3;
  
  @observable int currentPage = 1;
  @observable List<int> rowsPerPage = toObservable([3, 6, 9, 12]);
  @observable List visibleItems = toObservable([]);
  @observable int totalCount = 0;
  @observable int totalPages = 1;
  @observable String template;
  @observable List<int> rowIndices;
  @observable List<int> columnIndices;
  
  DatagridDataFetcher _dataFetcher;
  
  @observable Map<String, String> CUSTOM_TEMPLATES = toObservable({
    r'${datagrid:selectButton}':
      r'''
        <span title="View Detail" class="select-button">
          <span></span>
        </span>
      '''
  });
  
  DatagridComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    Element templateElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element, orElse: () => null);
    if (templateElement != null) {
      template = templateElement.parent.innerHtml;
    }
    $['hidden'].remove();
    
    if (data != null) {
      _dataFetcher = new DatagridClientDataFetcher(data);
    }
    else if (source != null) {
      _dataFetcher = new DatagridServerDataFetcher(Uri.parse(source));
    }
    
    loadPage(1);
  }
  
  void rowsPerPageTemplateChanged() {
    rowsPerPage = toObservable(rowsPerPageTemplate.split(',').map((String page) => int.parse(page)).toList(growable: false));
  }
  
  void totalCountChanged() {
    _refreshTotalPages();
  }
  
  void rowsChanged() {
    _refreshTotalPages();
    _refreshRowIndices();
    
    if (currentPage > totalPages && totalPages > 0) {
      currentPage = totalPages;
    }
    
    loadPage(currentPage);
  }
  
  void columnsChanged() {
    _refreshRowIndices();
    _refreshColumnIndices();
  }
  
  void currentPageChanged() {
    loadPage(currentPage);
  }
  
  void _refreshTotalPages() {
    int newTotalPages = (totalCount / rows).ceil();
    
    if (newTotalPages == 0) {
      totalPages = 1;
    }
    
    totalPages = newTotalPages;
  }
  
  void _refreshRowIndices() {
    rowIndices = toObservable(new Iterable.generate((rows / columns).ceil(), (int i) => i).toList(growable: false));
  }
  
  void _refreshColumnIndices() {
    columnIndices = toObservable(new Iterable.generate(columns, (int i) => i).toList(growable: false));
  }
  
  void onItemClicked(MouseEvent event, var detail, Element target) {
    TableCellElement cell = target.parent;
    TableRowElement row = cell.parent;
    
    int rowIndex = row.parent.children.indexOf(row) - 1;
    int columnIndex = cell.parent.children.indexOf(cell) - 1;
    
    this.dispatchEvent(new CustomEvent('selected', detail: visibleItems[rowIndex * columns + columnIndex]));
  }
  
  void loadPage(int page) {
    if (_dataFetcher == null) {
      return;
    }
    
    _dataFetcher.fetchData(page, rows).then((DatagridPacket result) {
      visibleItems = toObservable(result.data);
      totalCount = result.totalCount;
      
      _refreshRowIndices();
      _refreshColumnIndices();
    }).catchError((Object error) => print("An error occured: $error"));
  }
  
}