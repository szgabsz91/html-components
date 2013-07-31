part of autocomplete;

// FIXME if a class has a superclass and a mixin, the superclass ctor cannot be called
// therefore sharing functionality is implemented with top-level functions and duplicating common property '_property'

abstract class AutocompleteDataFetcher {
  int _maxresults;
  
  AutocompleteDataFetcher(int this._maxresults);
  
  Future<List> fetchSuggestions(String query);
}

class AutocompleteClientDataFetcher extends AutocompleteDataFetcher {
  List _suggestions;
  
  AutocompleteClientDataFetcher(int maxresults, List this._suggestions) : super(maxresults);
  
  Future<List> fetchSuggestions(String query) {
    Completer completer = new Completer();
  
    List result;
    
    if (_maxresults > 0) {
      result = _suggestions.where((String item) => item.toLowerCase().startsWith(query.toLowerCase()))
                           .take(_maxresults)
                           .toList(growable: false);
    }
    else {
      result = _suggestions.where((String item) => item.toLowerCase().startsWith(query.toLowerCase()))
                           .toList(growable: false);
    }
    
    completer.complete(result);
    
    return completer.future;
  }
}

class AutocompleteClientObjectDataFetcher extends AutocompleteClientDataFetcher {
  String _property;
  
  AutocompleteClientObjectDataFetcher(int maxresults, List suggestions, String this._property) : super(maxresults, suggestions);
  
  Future<List> fetchSuggestions(String query) {
    Completer completer = new Completer();
    
    List result;
    
    if (_maxresults > 0) {
      result = _suggestions.where((Object item) => _fitsCriteria(item, _property, query))
                           .take(_maxresults)
                           .toList(growable: false);
    }
    else {
      result = _suggestions.where((Object item) => _fitsCriteria(item, _property, query))
                           .toList(growable: false);
    }
    
    completer.complete(result);
    
    return completer.future;
  }
}

class AutocompleteServerDataFetcher extends AutocompleteDataFetcher {
  Uri _serviceURL;
  
  AutocompleteServerDataFetcher(Uri this._serviceURL, int maxresults) : super(maxresults);
  
  Future<List> fetchSuggestions(String query) {
    Completer completer = new Completer();
    
    HttpRequest.getString("${_serviceURL}?q=$query").then((String responseText) {
      List jsonList = json.parse(responseText);
      
      if (_maxresults > 0) {
        jsonList = jsonList.take(_maxresults).toList(growable: false);
      }
      
      completer.complete(jsonList);
    }).catchError((Object error) => print("An error occured: $error"));
    
    return completer.future;
  }
}

class AutocompleteServerObjectDataFetcher extends AutocompleteServerDataFetcher {
  String _property;
  
  AutocompleteServerObjectDataFetcher(Uri serviceURL, String this._property, int maxresults) : super(serviceURL, maxresults);
  
  Future<List> fetchSuggestions(String query) {
    Completer completer = new Completer();
    
    HttpRequest.getString("${_serviceURL}?q=$query&property=$_property").then((String responseText) {
      List jsonList = json.parse(responseText);
      
      if (_maxresults > 0) {
        jsonList = jsonList.take(_maxresults).toList(growable: false);
      }
      
      completer.complete(jsonList);
    }).catchError((Object error) => print("An error occured: $error"));
    
    return completer.future;
  }
}