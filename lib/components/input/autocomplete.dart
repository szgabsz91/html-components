library autocomplete;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "dart:json" as json;
import "../common/templates.dart";
import "../common/reflection.dart" as reflection;

part "autocomplete/functions.dart";
part "autocomplete/data.dart";
part "autocomplete/mode.dart";
part "autocomplete/model.dart";

class AutocompleteComponent extends WebComponent {
  AutocompleteModel model = new AutocompleteModel();
  
  DivElement get _hiddenArea => this.query(".x-autocomplete_ui-helper-hidden");
  TemplateElement get _templateElement => _hiddenArea.query("template");
  LIElement get _firstSuggestionElement => this.query(".x-autocomplete_ui-autocomplete-list-item");
  LIElement get _highlightedElement => this.query(".x-autocomplete_ui-state-highlight");
  TextInputElement get _inputField => this.query(".x-autocomplete_ui-inputfield");
  String get _inputValue => _inputField.value;
  
  static const EventStreamProvider<Event> _VALUE_CHANGED_EVENT = const EventStreamProvider<Event>("valueChanged");
  Stream<Event> get onValueChanged => _VALUE_CHANGED_EVENT.forTarget(this);
  static void _dispatchValueChangedEvent(Element element) {
    element.dispatchEvent(new Event("valueChanged"));
  }
  
  void inserted() {
    if (_templateElement != null) {
      model._templateManager = new TemplateManager(_templateElement.innerHtml);
    }
    
    _hiddenArea.remove();
  }
  
  get data => model.data;
  set data(var data) {
    model.data = data;
    _refreshSuggestionFetcher();
  }
  
  int get maxresults => model.maxResults;
  set maxresults(var maxresults) {
    if (maxresults is int) {
      model.maxResults = maxresults;
    }
    else if (maxresults is String) {
      model.maxResults = int.parse(maxresults);
    }
    else {
      throw new ArgumentError("The maxresults property must be of type int or String!");
    }
  }
  
  int get delay => model.delay;
  set delay(var delay) {
    if (delay is int) {
      model.delay = delay;
    }
    else if (delay is String) {
      model.delay = int.parse(delay);
    }
    else {
      throw new ArgumentError("The delay property must be of type int or String!");
    }
  }
  
  String get property => model.property;
  set property(String property) {
    model.property = property;
    _refreshSuggestionFetcher();
  }
  
  String get value => model.value;
  set value(String value) {
    model.value = value;
    _dispatchValueChangedEvent(this);
  }
  
  void _onKeyUp(KeyboardEvent event) {
    switch (event.which) {
      // Down arrow
      case 40:
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
        break;
      
      default:
        String query = _inputValue;
        
        if (query == "") {
          model.suggestions.clear();
          return;
        }
        
        new Future.delayed(new Duration(milliseconds: model.delay), () {
          if (query != _inputValue) {
            // Cancelled because query string changed
            return;
          }
          
          model._dataFetcher.fetchSuggestions(query).then((List<Object> suggestions) {
            if ([AutocompleteMode.CLIENT_OBJECT_NOTEMPLATE, AutocompleteMode.SERVER_OBJECT_NOTEMPLATE].contains(model._mode)) {
              model.suggestions = toObservable(
                suggestions.map((Object item) => reflection.getPropertyValue(item, model.property))
                           .toList(growable: false)
              );
            }
            else {
              model.suggestions = toObservable(suggestions);
            }
          }).catchError((Object error) => print("An error occured: $error"));
        });
    }
    
    if (![8, 16, 17, 18, 35, 36, 37, 39, 46].contains(event.which)) {
      // Same as in masked input (placeCursor)
      _inputField.selectionStart = _inputValue.length;
    }
  }
  
  void _onKeyPress(KeyboardEvent event) {
    if (_highlightedElement != null && event.which == 13) {
      event.preventDefault();
    }
  }
  
  void _onMouseOverSuggestion(LIElement suggestionElement) {
    Element highlightedSuggestion = _highlightedElement;
    if (highlightedSuggestion != null) {
      highlightedSuggestion.classes.remove("x-autocomplete_ui-state-highlight");
    }
    
    suggestionElement.classes.add("x-autocomplete_ui-state-highlight");
  }
  
  void _onSuggestionClicked() {
    if (_highlightedElement != null) {
      if ([AutocompleteMode.CLIENT_OBJECT_TEMPLATE, AutocompleteMode.SERVER_OBJECT_TEMPLATE].contains(model._mode)) {
        int index = _highlightedElement.parent.queryAll(".x-autocomplete_ui-autocomplete-list-item").indexOf(_highlightedElement);
        Object item = model.suggestions[index];
        model.value = reflection.getPropertyValue(item, model.property);
      }
      else {
        model.value = _highlightedElement.text.trim();
      }
      
      model.suggestions.clear();
      _dispatchValueChangedEvent(this);
    }
  }
  
  void _refreshSuggestionFetcher() {
    if (model.data is String) {
      RegExp regExp = new RegExp(r"\[(.*)\]");
      
      if (regExp.hasMatch(model.data)) {
        // Bound list
        List<String> possibilities = model.data.substring(1, model.data.length - 1).split(", ");
        model._dataFetcher = new AutocompleteClientDataFetcher(model.maxResults, possibilities);
      }
      else {
        // URL
        Uri serviceURL = Uri.parse(model.data);
        
        if (model.property == null) {
          model._dataFetcher = new AutocompleteServerDataFetcher(serviceURL, model.maxResults);
        }
        else {
          model._dataFetcher = new AutocompleteServerObjectDataFetcher(serviceURL, model.property, model.maxResults);
        }
      }
    }
    else if (model.data is List) {
      if (model.data.first is String) {
        // List of Strings
        model._dataFetcher = new AutocompleteClientDataFetcher(model.maxResults, model.data);
      }
      else {
        // List of Objects
        model._dataFetcher = new AutocompleteClientObjectDataFetcher(model.maxResults, model.data, model.property);
      }
    }
  }
  
  SafeHtml _getSuggestionAsHtml(Object suggestion) {
    String htmlString = model._templateManager.getSubstitutedString(suggestion);
    return new SafeHtml.unsafe("<span>${htmlString}</span>");
  }
}