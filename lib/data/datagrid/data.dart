import 'dart:html';
import 'dart:async';
import 'dart:convert';

class DatagridPacket {
  List<Object> data;
  int totalCount;
  
  DatagridPacket(List<Object> this.data, int this.totalCount);
}

abstract class DatagridDataFetcher {
  Future<DatagridPacket> fetchData(int page, int rows);
}

class DatagridClientDataFetcher extends DatagridDataFetcher {
  List<Object> _data;
  
  DatagridClientDataFetcher(List<Object> this._data);
  
  Future<DatagridPacket> fetchData(int page, int rows) {
    Completer completer = new Completer();
    
    if (page == 0) {
      completer.complete(new DatagridPacket([], 0));
      return completer.future;
    }
    
    List<Object> result = _data.skip((page - 1) * rows)
                               .take(rows)
                               .toList(growable: false);
    int totalCount = _data.length;
    
    completer.complete(new DatagridPacket(result, totalCount));
    
    return completer.future;
  }
}

class DatagridServerDataFetcher extends DatagridDataFetcher {
  Uri _serviceURL;
  
  DatagridServerDataFetcher(Uri this._serviceURL);
  
  Future<DatagridPacket> fetchData(int page, int rows) {
    Completer completer = new Completer();
    
    if (page == 0) {
      completer.complete(new DatagridPacket([], 0));
      return completer.future;
    }
    
    HttpRequest.getString("${_serviceURL}?page=${page}&rows=${rows}").then((String responseText) {
      Map resultMap = JSON.decode(responseText);
      
      completer.complete(new DatagridPacket(resultMap["result"], resultMap["totalCount"]));
    }).catchError((Object error) => print("An error occured: $error"));
    
    return completer.future;
  }
}