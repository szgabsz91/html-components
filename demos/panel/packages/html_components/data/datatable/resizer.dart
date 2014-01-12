import 'dart:html';

class ColumnResizer {
  TableCellElement _resizingColumn;
  TableCellElement _siblingColumn;
  
  static const int CELL_PADDING = 10;
  
  TableCellElement get resizingColumn => _resizingColumn;
  set resizingColumn(TableCellElement resizingColumn) {
    _resizingColumn = resizingColumn;
    
    if (resizingColumn == null) {
      return;
    }
    
    _siblingColumn = resizingColumn.nextElementSibling;
    if (_siblingColumn == null) {
      _siblingColumn = resizingColumn.previousElementSibling;
      
      if (_siblingColumn == null) {
        _siblingColumn = new TableCellElement();
      }
    }
    
    resizingColumn.style.width = "${_getWidthOfColumn(resizingColumn)}px";
    _siblingColumn.style.width = "${_getWidthOfColumn(_siblingColumn)}px";
  }
  
  void resize(int pixel) {
    int resizingColumnWidth = _getWidthOfColumn(resizingColumn);
    int nextColumnWidth = _getWidthOfColumn(_siblingColumn);
    
    resizingColumnWidth += pixel;
    nextColumnWidth -= pixel;
    
    resizingColumn.style.width = "${resizingColumnWidth}px";
    _siblingColumn.style.width = "${nextColumnWidth}px";
  }
  
  int _getWidthOfColumn(Element column) {
    if (column.style.width != "") {
      return _getSizeAsInt(column.style.width);
    }
    
    return column.clientWidth - 2 * CELL_PADDING;
  }
  
  int _getSizeAsInt(String size) {
    String result = new RegExp(r"\d+").firstMatch(size).group(0);
    return int.parse(result);
  }
}