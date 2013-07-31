part of datatable;

class SortDirection {
  final int _index;
  
  const SortDirection(int this._index);
  
  static const ASCENDING = const SortDirection(0);
  static const DESCENDING = const SortDirection(1);
  
  static const values = const [
    ASCENDING,
    DESCENDING
  ];
  
  String toString() {
    if (_index == 0) {
      return "asc";
    }
    
    return "desc";
  }
}

@observable
class Sort {
  ColumnModel column;
  SortDirection direction;
  
  Sort(ColumnModel this.column, SortDirection this.direction);
  
  String toString() => "Sort[column=${column.property}, direction=${direction}]";
  
  Map<String, dynamic> toJson() {
    return {"property": column.property, "direction": direction.toString()};
  }
}