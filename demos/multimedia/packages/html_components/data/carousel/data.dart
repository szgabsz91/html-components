import 'dart:html';
import 'dart:async';
import 'dart:convert';

abstract class CarouselDataFetcher {
  Future<List<Object>> fetchData();
}

class CarouselClientDataFetcher extends CarouselDataFetcher {
  List<Object> _data;
  
  CarouselClientDataFetcher(List<Object> this._data);
  
  Future<List<Object>> fetchData() {
    Completer completer = new Completer();
    
    completer.complete(_data);
    
    return completer.future;
  }
}

class CarouselServerDataFetcher extends CarouselDataFetcher {
  Uri _serviceURL;
  
  CarouselServerDataFetcher(Uri this._serviceURL);
  
  Future<List<Object>> fetchData() {
    Completer completer = new Completer();
    
    HttpRequest.getString("${_serviceURL}").then((String responseText) {
      List resultList = JSON.decode(responseText);
      completer.complete(resultList);
    }).catchError((Object error) => print("An error occured: $error"));
    
    return completer.future;
  }
}