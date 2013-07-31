part of datatable;

class FilterOperator {
  final int _index;
  
  const FilterOperator(int this._index);
  
  static const CONTAINS = const FilterOperator(0);
  static const EQUALS = const FilterOperator(1);
  static const LESS_THAN = const FilterOperator(2);
  static const GREATER_THAN = const FilterOperator(3);
  static const IN = const FilterOperator(4);
  
  static const values = const [
    CONTAINS,
    EQUALS,
    LESS_THAN,
    GREATER_THAN,
    IN
  ];
  
  String toString() {
    switch (_index) {
      case 0:
        return "contains";
      
      case 1:
        return "eq";
      
      case 2:
        return "lt";
      
      case 3:
        return "gt";
      
      case 4:
        return "in";
    }
  }
}

abstract class FilterListener {
  void onFilterChanged(Filter filter);
}

@observable
abstract class Filter<T> {
  String property;
  FilterOperator operator;
  T _value;
  List<FilterListener> _listeners = <FilterListener>[];
  
  Filter(String this.property, FilterOperator this.operator, T this._value, [FilterListener listener = null]) {
    if (listener != null) {
      _listeners.add(listener);
    }
  }
  
  T get value => _value;
  set value(T value) {
    _value = value;
    _listeners.forEach((FilterListener listener) => listener.onFilterChanged(this));
  }
  
  void addFilterListener(FilterListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }
  
  void removeFilterListener(FilterListener listener) {
    if (_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }
}

class ValueFilter extends Filter<String> {
  ValueFilter(String property, FilterOperator operator, String value, [FilterListener listener = null]) : super(property, operator, value, listener);
}

class CheckedFilter extends Filter<bool> {
  CheckedFilter(String property, FilterOperator operator, bool value, [FilterListener listener = null]) : super(property, operator, value, listener);
}