part of datatable;

@observable
class DatatableModel {
  ObservableList<ColumnModel> _columns = new ObservableList();
  String header;
  String footer;
  int rows = 10;
  ObservableList<TemplateManager> _columnTemplateManagers = new ObservableList();
  ObservableList<Object> __visibleItems = new ObservableList();
  ObservableList selectedItems = new ObservableList();
  String _paginatorPosition = "bottom";
  int totalCount = 0;
  DatatableDataFetcher _dataFetcher;
  ObservableList<Sort> __sorts = new ObservableList();
  bool _multipleMode = false;
  ObservableMap<ColumnModel, List<Filter>> __filters = new ObservableMap();
  String _selection = "none";
  TemplateManager rowExpansionTemplate;
  
  ObservableList<ColumnModel> get columns => _columns;
  set columns(List<ColumnModel> columns) {
    if (columns is ObservableList) {
      _columns = columns;
    }
    else {
      _columns = toObservable(columns);
    }
  }
  
  bool get showColumnHeader => columns.any((ColumnModel column) => column.header != null);
  
  SafeHtml get _safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
  
  String get _replacedFooter => footer.replaceAll(r"${datatable:totalCount}", totalCount.toString());
  SafeHtml get _safeFooter => new SafeHtml.unsafe("<span>${_replacedFooter}</span>");
  
  bool get showColumnFooter => columns.any((ColumnModel column) => column.footer != null);
  
  String get rows_bindable => rows.toString();
  set rows_bindable(String rows_bindable) => rows = int.parse(rows_bindable);
  
  ObservableList<TemplateManager> get columnTemplateManagers => _columnTemplateManagers;
  set columnTemplateManagers(List<TemplateManager> columnTemplateManagers) {
    if (columnTemplateManagers is ObservableList) {
      _columnTemplateManagers = columnTemplateManagers;
    }
    else {
      _columnTemplateManagers = toObservable(columnTemplateManagers);
    }
  }
  
  ObservableList<Object> get _visibleItems => __visibleItems;
  set _visibleItems(List<Object> visibleItems) {
    if (visibleItems is ObservableList) {
      __visibleItems = visibleItems;
    }
    else {
      __visibleItems = toObservable(visibleItems);
    }
  }
  
  String get paginatorPosition => _paginatorPosition;
  set paginatorPosition(String paginatorPosition) {
    if (["top", "bottom", "both"].contains(paginatorPosition)) {
      _paginatorPosition = paginatorPosition;
    }
    else {
      throw new ArgumentError("The paginatorPosition property must be top, bottom or both!");
    }
  }
  
  Object get selectedItem {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    return selectedItems.first;
  }
  set selectedItem(Object selectedItem) {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    selectedItems.clear();
    selectedItems.add(selectedItem);
  }
  
  int get totalPages {
    int result = (totalCount / rows).ceil();
    
    if (result == 0) {
      return 1;
    }
    
    return result;
  }
  
  ObservableList<Sort> get _sorts => __sorts;
  
  ObservableMap<ColumnModel, List<Filter>> get _filters => __filters;
  
  String get selection => _selection;
  set selection(String selection) {
    if (["none", "single", "multiple"].contains(selection)) {
      _selection = selection;
    }
    else {
      throw new ArgumentError("The selection property must be none, single or multiple!");
    }
  }
}