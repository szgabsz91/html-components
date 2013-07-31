part of paginator;

@observable
class PaginatorModel {
  String position;
  int currentPage = 1;
  int totalPages = 1;
  int maxPageLinks = 5;
  ObservableList<int> _rowsPerPage = toObservable([4, 8, 12, 16, 20]);
  int rows = 20;
  
  ObservableList<int> get rowsPerPage => _rowsPerPage;
  set rowsPerPage(List<Object> rowsPerPage) {
    if (rowsPerPage is ObservableList) {
      _rowsPerPage = rowsPerPage;
    }
    else {
      _rowsPerPage = toObservable(rowsPerPage);
    }
  }
  
  String get _rows_bindable => rows.toString();
  set _rows_bindable(String rows_bindable) => rows = int.parse(rows_bindable);
}