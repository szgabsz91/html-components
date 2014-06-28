import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'column.dart';
import 'row_expansion.dart';
import 'datatable/sort.dart';
import 'datatable/filter.dart';
import 'datatable/resizer.dart';
import 'datatable/editor.dart';
import 'datatable/data.dart';
import '../common/reflection.dart' as reflection;

@CustomTag('h-datatable')
class DatatableComponent extends PolymerElement with FilterListener {
  
  @published int rows = 16;
  @published String paginatorPosition = 'none';
  @published String rowsPerPageTemplate = '10,15,20';
  @published List data;
  @published String source;
  @published int maxPageLinks = 10;
  @published String selection = 'none';
  
  @observable int currentPage = 1;
  @observable List<int> rowsPerPage = toObservable([10, 15, 20]);
  @observable int totalCount = 0;
  @observable int totalPages = 1;
  @observable bool showColumnHeader = true;
  @observable bool showColumnFooter = true;
  @observable List<ColumnModel> columns = toObservable([]);
  @observable String header;
  @observable String footer;
  @observable String rowExpansionTemplate;
  @observable List visibleItems = toObservable([]);
  @observable List selectedItems = toObservable([]);
  @observable List<Sort> sorts = toObservable([]);
  @observable Map<ColumnModel, List<Filter>> filters = toObservable({});
  
  DatatableDataFetcher _dataFetcher;
  bool _selectMultiple = false;
  Point _mousePosition;
  ColumnResizer _columnResizer = new ColumnResizer();
  @observable ClientCellEditor cellEditor;
  
  @observable Map<String, String> CUSTOM_TEMPLATES = toObservable({
    r'${datatable:totalCount}':
      '0'
  });
  
  DatatableComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    scheduleMicrotask(() {
      List<ColumnComponent> columnComponents = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is ColumnComponent).toList(growable: false);
      
      columnComponents.forEach((ColumnComponent columnComponent) {
        ColumnModel columnModel = columnComponent.model;
        columns.add(columnModel);
        
        if (columnModel.type == 'string') {
          filters[columnModel] = [
            new ValueFilter(columnModel.property, FilterOperator.CONTAINS, "", this)
          ];
        }
        else if (columnModel.type == 'numeric') {
          filters[columnModel] = [
            new ValueFilter(columnModel.property, FilterOperator.EQUALS, "", this),
            new ValueFilter(columnModel.property, FilterOperator.LESS_THAN, "", this),
            new ValueFilter(columnModel.property, FilterOperator.GREATER_THAN, "", this)
          ];
        }
        else if (columnModel.type == 'boolean') {
          filters[columnModel] = [
            new CheckedFilter(columnModel.property, FilterOperator.EQUALS, false, this),
            new CheckedFilter(columnModel.property, FilterOperator.EQUALS, false, this)
          ];
        }
      });
      
      showColumnHeader = columns.any((ColumnModel column) => column.header != null);
      showColumnFooter = columns.any((ColumnModel column) => column.footer != null);
      
      Element headerElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element && node.tagName == 'HEADER', orElse: () => null);
      if (headerElement != null) {
        header = headerElement.innerHtml;
      }
      
      Element footerElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element && node.tagName == 'FOOTER', orElse: () => null);
      if (footerElement != null) {
        footer = footerElement.innerHtml;
      }
      
      RowExpansionComponent rowExpansionComponent = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is RowExpansionComponent, orElse: () => null);
      if (rowExpansionComponent != null) {
        rowExpansionTemplate = rowExpansionComponent.content;
      }
      
      $['hidden'].remove();
    });
    
    document.onMouseMove.listen(_onColumnResizing);
    document.onMouseUp.listen(_onColumnResizeStopped);
    document.onKeyDown.listen(_onKeyDown);
    document.onKeyUp.listen(_onKeyUp);
    
    if (data != null) {
      _dataFetcher = new DatatableClientDataFetcher(data);
      cellEditor = new ClientCellEditor();
    }
    else if (source != null) {
      Uri serviceURL = Uri.parse(source);
      _dataFetcher = new DatatableServerDataFetcher(serviceURL);
      cellEditor = new ServerCellEditor(serviceURL);
    }
    
    loadPage(1);
  }
  
  void rowsPerPageTemplateChanged() {
    rowsPerPage = toObservable(rowsPerPageTemplate.split(',').map((String page) => int.parse(page)).toList(growable: false));
  }
  
  void totalCountChanged() {
    CUSTOM_TEMPLATES = toObservable({
      r'${datatable:totalCount}':
        totalCount.toString()
    });
    
    _refreshTotalPages();
  }
  
  void rowsChanged() {
    _refreshTotalPages();
    
    if (currentPage > totalPages && totalPages > 0) {
      currentPage = totalPages;
    }
    
    loadPage(currentPage);
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
  
  // This was needed because of a bug: page 1 --> page 2 --> page 1 and still the 2nd page was displayed
  void newPageRequested(CustomEvent event, int detail, Element target) {
    if (currentPage != detail) {
      currentPage = detail;
    }
  }
  
  void loadPage(int page) {
    if (_dataFetcher == null) {
      return;
    }
    
    if (_dataFetcher != null) {
      _dataFetcher.fetchData(page, rows, sorts, filters).then((DatatablePacket result) {
        visibleItems = toObservable(result.data);
        totalCount = result.totalCount;
      }).catchError((Object error) => print("An error occured: $error"));
    }
  }
  
  void onColumnResizeStarted(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    _mousePosition = new Point(event.page.x, event.page.y);
    
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
    
    this.dispatchEvent(new Event('columnresized'));
  }
  
  void _onKeyDown(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      _selectMultiple = true;
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      _selectMultiple = false;
    }
  }
  
  void onColumnHeaderMouseOver(MouseEvent event, var detail, Element target) {
    int columnIndex = target.parent.children.indexOf(target) - 1;
    ColumnModel column = columns[columnIndex];
    
    if (!column.sortable) {
      return;
    }
    
    if (!target.classes.contains("selected")) {
      target.classes.add("hover");
    }
    else {
      target.classes.remove("hover");
    }
  }
  
  void onColumnHeaderMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onColumnHeaderClicked(MouseEvent event, var detail, Element target) {
    int columnIndex = target.parent.children.indexOf(target) - 1;
    ColumnModel column = columns[columnIndex];
    
    if (!column.sortable) {
      return;
    }
    
    Sort sort = getSortByColumn(column);
    
    if (!_selectMultiple) {
      sorts.removeWhere((Sort currentSort) => currentSort != sort);
    }
    
    if (sort == null) {
      Sort sort = new Sort(column, SortDirection.ASCENDING);
      sorts.add(sort);
      column.sort = sort;
    }
    else {
      if (sort.direction == SortDirection.ASCENDING) {
        sorts.remove(sort);
        Sort newSort = new Sort(column, SortDirection.DESCENDING);
        sorts.add(newSort);
        column.sort = newSort;
      }
      else {
        sorts.remove(sort);
        column.sort = null;
      }
    }
    
    _dataFetcher.fetchData(currentPage, rows, sorts, filters).then((DatatablePacket result) {
      visibleItems = result.data;
      totalCount = result.totalCount;
      
      this.dispatchEvent(new CustomEvent('sorted', detail: column.header));
    }).catchError((Object error) => print("An error occured: $error"));
  }
  
  void onFilterIconClicked(MouseEvent event, var detail, Element target) {
    DivElement filterContent = target.parent.querySelector('.filter-content');
    
    filterContent.classes.toggle('invisible');
  }
  
  void onFiltered(Filter filter) {
    new Future.delayed(new Duration(milliseconds: 100), () {
      _dataFetcher.fetchData(currentPage, rows, sorts, filters).then((DatatablePacket result) {
        visibleItems = toObservable(result.data);
        totalCount = result.totalCount;
      }).catchError((Object error) => print("An error occured: $error"));
    });
    
    this.dispatchEvent(new Event('filtered'));
  }
  
  void onRowMouseOver(MouseEvent event, var detail, Element target) {
    if (selection == "none") {
      return;
    }
    
    int itemIndex = target.parent.parent.children.indexOf(target.parent) - 3;
    Object item = visibleItems[itemIndex];
    
    if (selectedItems.contains(item)) {
      return;
    }
    
    target.classes.add("hover");
  }
  
  void onRowMouseOut(MouseEvent event, var detail, Element target) {
    if (selection == "none") {
      return;
    }
    
    int itemIndex = target.parent.parent.children.indexOf(target.parent) - 3;
    Object item = visibleItems[itemIndex];
    
    if (selectedItems.contains(item)) {
      return;
    }
    
    target.classes.remove("hover");
  }
  
  void onRowClicked(MouseEvent event, var detail, Element target) {
    if (selection == "none") {
      return;
    }
    
    int itemIndex = target.parent.parent.children.indexOf(target.parent) - 3;
    Object item = visibleItems[itemIndex];
    
    event.preventDefault();
    
    if (selection == 'multiple') {
      if (_selectMultiple) {
        if (selectedItems.contains(item)) {
          List newList = toObservable([]);
          newList.addAll(selectedItems);
          newList.remove(item);
          selectedItems = newList;
        }
        else {
          List newList = toObservable([]);
          newList.addAll(selectedItems);
          newList.add(item);
          selectedItems = newList;
        }
      }
      else {
        if (!selectedItems.contains(item)) {
          selectedItems = toObservable([item]);
        }
        else {
          selectedItems = toObservable([]);
        }
      }
    }
    else {
      if (selectedItems.contains(item)) {
        selectedItems = toObservable([]);
      }
      else {
        selectedItems = toObservable([item]);
      }
    }
    
    this.dispatchEvent(new Event('selected'));
  }
  
  void onCellDoubleClicked(MouseEvent event, var detail, Element target) {
    int columnIndex = target.parent.children.indexOf(target) - 1;
    ColumnModel column = columns[columnIndex];
    
    int itemIndex = target.parent.parent.parent.children.indexOf(target.parent.parent) - 3;;
    Object item = visibleItems[itemIndex];
    
    if (!column.editable) {
      return;
    }
    
    event.preventDefault();
    
    cellEditor.startEditing(column, item);
  }
  
  void onEditorKeyDown(KeyboardEvent event, var detail, InputElement target) {
    switch (event.which) {
      // Esc
      case 27:
        cellEditor.cancelEditing();
        break;
      
      // Enter
      case 13:
        Object newValue = target.value;
        if (target.type == 'number') {
          newValue = int.parse(newValue);
        }
        cellEditor.acceptEditing(newValue);
        this.dispatchEvent(new Event('edited'));
        break;
    }
  }
  
  void onCheckboxClicked(MouseEvent event, var detail, CheckboxInputElement target) {
    event.preventDefault();
    bool checked = target.checked;
    cellEditor.acceptEditing(!checked);
  }
  
  void onRowExpansionIconClicked(MouseEvent event, var detail, Element target) {
    TableRowElement expansionRow = target.parent.parent.parent.querySelector('.expansion-row');
    
    if (target.classes.contains("circle-triangle-e")) {
      target.classes.remove("circle-triangle-e");
      target.classes.add("circle-triangle-s");
      expansionRow.style.display = "table-row";
    }
    else {
      target.classes.remove("circle-triangle-s");
      target.classes.add("circle-triangle-e");
      expansionRow.style.display = "none";
    }
    
    this.dispatchEvent(new Event('rowtoggled'));
  }
  
  Sort getSortByColumn(ColumnModel column) {
    return sorts.firstWhere((Sort sort) => sort.column == column, orElse: () => null);
  }
  
  Object getItemProperty(Object item, String property) {
    return reflection.getPropertyValue(item, property);
  }
  
}