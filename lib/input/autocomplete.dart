import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'autocomplete/data.dart';
import '../common/reflection.dart' as reflection;

@CustomTag('h-autocomplete')
class AutocompleteComponent extends PolymerElement {
  
  @published int maxResults = 0;
  @published int delay = 1000;
  @published String property;
  @published List data = toObservable([]);
  @published String source;
  
  @observable List suggestions = toObservable([]);
  @observable String value = '';
  @observable String template;
  
  AutocompleteDataFetcher _dataFetcher;
  
  static const int CLIENT_STRING = 0;
  static const int SERVER_STRING = 1;
  static const int CLIENT_OBJECT_TEMPLATE = 2;
  static const int CLIENT_OBJECT_NOTEMPLATE = 3;
  static const int SERVER_OBJECT_TEMPLATE = 4;
  static const int SERVER_OBJECT_NOTEMPLATE = 5;
  
  int get _mode {
    if (property == null && _dataFetcher is AutocompleteClientDataFetcher) {
      return CLIENT_STRING;
    }
    else if (property == null && _dataFetcher is AutocompleteServerDataFetcher) {
      return SERVER_STRING;
    }
    else if (property != null && _dataFetcher is AutocompleteClientObjectDataFetcher && template != null) {
      return CLIENT_OBJECT_TEMPLATE;
    }
    else if (property != null && _dataFetcher is AutocompleteClientObjectDataFetcher && template == null) {
      return CLIENT_OBJECT_NOTEMPLATE;
    }
    else if (property != null && _dataFetcher is AutocompleteServerObjectDataFetcher && template != null) {
      return SERVER_OBJECT_TEMPLATE;
    }
    else if (property != null && _dataFetcher is AutocompleteServerObjectDataFetcher && template == null) {
      return SERVER_OBJECT_NOTEMPLATE;
    }
    else {
      throw new UnsupportedError('Unsupported autocomplete mode!');
    }
  }
  
  AutocompleteComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    List<Node> children = $['hidden'].querySelector('content').getDistributedNodes();
    
    if (children.isNotEmpty) {
      template = children.first.parent.innerHtml;
    }
    
    _refreshSuggestionFetcher();
    
    $['hidden'].remove();
  }
  
  void onContainerKeyUp(KeyboardEvent event) {
    switch (event.which) {
      // Down arrow
      /*case 40:
        if (_highlightedElement != null) {
          Element nextElement = _highlightedElement.nextElementSibling;
          if (nextElement != null && nextElement.tagName == _highlightedElement.tagName) {
            _onMouseOverSuggestion(nextElement);
          }
        }
        else {
          _onMouseOverSuggestion(_firstSuggestionElement);
        }
        break;
      
      // Up arrow
      case 38:
        if (_highlightedElement != null) {
          Element previousElement = _highlightedElement.previousElementSibling;
          if (previousElement != null && previousElement.tagName == _highlightedElement.tagName) {
            _onMouseOverSuggestion(previousElement);
          }
        }
        break;
      
      // Enter
      case 13:
        _onSuggestionClicked();
        break;*/
      
      default:
        String query = value;
        
        if (query == '') {
          suggestions.clear();
          $['suggestion-container'].classes.add('hidden');
          return;
        }
        
        new Future.delayed(new Duration(milliseconds: delay), () {
          if (query != value) {
            // Cancelled because query string changed
            return;
          }
          
          _dataFetcher.fetchSuggestions(query).then((List<Object> suggestions) {
            if ([CLIENT_OBJECT_NOTEMPLATE, SERVER_OBJECT_NOTEMPLATE].contains(_mode)) {
              this.suggestions = toObservable(
                suggestions.map((Object item) => reflection.getPropertyValue(item, property))
                           .toList(growable: false)
              );
            }
            else {
              this.suggestions = toObservable(suggestions);
            }
            
            $['suggestion-container'].classes.remove('hidden');
          }).catchError((Object error) => print("An error occured: $error"));
        });
    }
    
    if (![8, 16, 17, 18, 35, 36, 37, 39, 46].contains(event.which)) {
      // Same as in masked input (placeCursor)
      $['input'].selectionStart = value.length;
    }
  }
  
  void onSuggestionMouseOver(MouseEvent event, var detail, Element target) {
    target.classes.add('hover');
  }
  
  void onSuggestionMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onSuggestionClicked(MouseEvent event, var detail, Element target) {
    if ([CLIENT_OBJECT_TEMPLATE, SERVER_OBJECT_TEMPLATE].contains(_mode)) {
      int index = target.parent.children.indexOf(target) - 1;
      Object item = suggestions[index];
      value = reflection.getPropertyValue(item, property);
    }
    else {
      value = target.text.trim();
    }
    
    suggestions.clear();
    $['suggestion-container'].classes.add('hidden');
    
    this.dispatchEvent(new Event('valuechanged'));
  }
  
  void _refreshSuggestionFetcher() {
    if (source != null) {
      // URL
      Uri serviceURL = Uri.parse(source);
      
      if (property == null) {
        _dataFetcher = new AutocompleteServerDataFetcher(serviceURL, maxResults);
      }
      else {
        _dataFetcher = new AutocompleteServerObjectDataFetcher(serviceURL, property, maxResults);
      }
    }
    else {
      if (data.first is String) {
        // List of Strings
        _dataFetcher = new AutocompleteClientDataFetcher(maxResults, data);
      }
      else {
        // List of Objects
        _dataFetcher = new AutocompleteClientObjectDataFetcher(maxResults, data, property);
      }
    }
  }
  
}