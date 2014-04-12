import '../column/model.dart';
import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'sort.dart';
import 'filter.dart';
import '../../common/reflection.dart' as reflection;

class DatatablePacket {
  List<Object> data;
  int totalCount;
  
  DatatablePacket(List<Object> this.data, int this.totalCount);
}

abstract class DatatableDataFetcher {
  Future<DatatablePacket> fetchData(int page, int rows, List<Sort> sorts, Map<ColumnModel, List<Filter>> filters);
  
  List<Filter> _getValidFilters(List<Filter> filters) {
    return filters.where((Filter filter) => filter.value != "" && filter.value != false)
                  .toList(growable: false);
  }
}

class DatatableClientDataFetcher extends DatatableDataFetcher {
  List<Object> _objects;
  
  DatatableClientDataFetcher(List<Object> this._objects);
  
  Future<DatatablePacket> fetchData(int page, int rows, List<Sort> sorts, Map<ColumnModel, List<Filter>> filters) {
    Completer completer = new Completer();
    
    if (page == 0) {
      completer.complete(new DatatablePacket(<Object>[], 0));
      return completer.future;
    }
    
    List<Object> result = _objects.toList(growable: false);
    
    filters.keys.forEach((ColumnModel column) {
      List<Filter> validFilters = _getValidFilters(filters[column]);
      
      if (validFilters.isNotEmpty) {
        switch (column.type) {
          case "string":
            result = result.where((Object item) {
              String value = reflection.getPropertyValue(item, column.property);
              return value.toLowerCase().contains(validFilters.first.value.toLowerCase());
            }).toList(growable: false);
            break;
          
          case "numeric":
            result = result.where((Object item) {
              num value = reflection.getPropertyValue(item, column.property);
              bool result = false;
              
              for (Filter filter in validFilters) {
                num referenceValue = double.parse(filter.value);
                
                switch (filter.operator) {
                  case FilterOperator.LESS_THAN:
                    result = result || value < referenceValue;
                    break;
                  
                  case FilterOperator.GREATER_THAN:
                    result = result || value > referenceValue;
                    break;
                  
                  case FilterOperator.EQUALS:
                    result = result || value == referenceValue;
                    break;
                }
              }
              
              return result;
            }).toList(growable: false);
            break;
          
          case "boolean":
            result = result.where((Object item) {
              bool value = reflection.getPropertyValue(item, column.property);
              
              return (filters[column].first.value && value) ||
                     (filters[column].last.value && !value);
            }).toList(growable: false);
            break;
        }
      }
    });
    
    if (sorts.isNotEmpty) {
      result.sort((Object item1, Object item2) {
        for (Sort sort in sorts) {
          Object value1 = reflection.getPropertyValue(item1, sort.column.property);
          Object value2 = reflection.getPropertyValue(item2, sort.column.property);
          
          if (value1 is bool || value2 is bool) {
            value1 = value1.toString();
            value2 = value2.toString();
          }
          
          int result = Comparable.compare(value1, value2);
          
          if (result != 0) {
            if (sort.direction == SortDirection.ASCENDING) {
              return result;
            }
            else {
              return -result;
            }
          }
        }
        
        return 0;
      });
    }
    
    int totalCount = result.length;
    
    if ((page) * rows > totalCount) {
      page = (totalCount / rows).ceil();
    }
    if (page == 0) {
      page = 1;
    }
    
    result = result.skip((page - 1) * rows)
                   .take(rows)
                   .toList(growable: false);
    
    completer.complete(new DatatablePacket(result, totalCount));
    
    return completer.future;
  }
}

class DatatableServerDataFetcher extends DatatableDataFetcher {
  Uri _serviceURL;
  
  DatatableServerDataFetcher(Uri this._serviceURL);
  
  Future<DatatablePacket> fetchData(int page, int rows, List<Sort> sorts, Map<ColumnModel, List<Filter>> filters) {
    Completer completer = new Completer();
    
    List<Map<String, dynamic>> filterMapList = _filtersToJson(filters);
    Map<String, dynamic> data = {
      "sorts": sorts,
      "filters": filterMapList
    };
    
    String url = "${_serviceURL}?page=${page}&rows=${rows}";
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        Map<String, dynamic> jsonMap = JSON.decode(request.responseText);
        
        List<Object> result = jsonMap["result"];
        int totalCount = jsonMap["totalCount"];
        
        completer.complete(new DatatablePacket(result, totalCount));
      }
    });
    
    request.open("POST", url, async: false);
    request.send(JSON.encode(data));
    
    return completer.future;
  }
  
  List<Map<String, dynamic>> _filtersToJson(Map<ColumnModel, List<Filter>> filters) {
    List<Map<String, dynamic>> result = [];
    
    filters.keys.forEach((ColumnModel column) {
      List<Filter> filterList = filters[column];
      
      Map<String, dynamic> item = {
        "column": <String, String>{
          "type": column.type,
          "property": column.property
        },
        
        "filters": 
          column.type == "boolean"
          ?
            _getBooleanFilterMap(filterList)
          :
            _getValidFilters(filterList).map((Filter filter) => {
              "operator": filter.operator.toString(),
              "value": filter.value
            }).toList(growable: false)
      };
      
      if ((item["filters"].isNotEmpty && item["filters"].first["operator"] != "in") || (item["filters"].isNotEmpty && item["filters"].first["operator"] == "in" && item["filters"].first["value"].isNotEmpty)) {
        result.add(item);
      }
    });
    
    return result;
  }
  
  List<Map<String, dynamic>> _getBooleanFilterMap(List<Filter> filters) {
    bool trueAllowed = filters.first.value;
    bool falseAllowed = filters.last.value;
    
    List<bool> allowedValues = [];
    if (trueAllowed) {
      allowedValues.add(true);
    }
    if (falseAllowed) {
      allowedValues.add(false);
    }
    
    return [
      {
        "operator": FilterOperator.IN.toString(),
        "value": allowedValues
      }
    ];
  }
}