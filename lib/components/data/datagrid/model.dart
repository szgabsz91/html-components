part of datagrid;

@observable
class DatagridModel {
  bool selectable = true;
  int columns = 4;
  int rows = 16;
  String _paginatorPosition = "bottom";
  int totalCount = 0;
  ObservableList<Object> __visibleItems = new ObservableList();
  DatagridTemplateManager _templateManager;
  DatagridDataFetcher _dataFetcher;
  
  String get paginatorPosition => _paginatorPosition;
  set paginatorPosition(String paginatorPosition) {
    if (["top", "bottom", "both"].contains(paginatorPosition)) {
      _paginatorPosition = paginatorPosition;
    }
    else {
      throw new ArgumentError("The paginatorPosition property must be top, bottom or both!");
    }
  }
  
  int get totalPages {
    int result = (totalCount / rows).ceil();
    
    if (result == 0) {
      return 1;
    }
    
    return result;
  }
  
  ObservableList<Object> get _visibleItems => __visibleItems;
  set _visibleItems(List<Object> visibleItems) {
    if (visibleItems is ObservableList) {
      __visibleItems = visibleItems;
    }
    else if (visibleItems is List) {
      __visibleItems = toObservable(visibleItems);
    }
  }
}