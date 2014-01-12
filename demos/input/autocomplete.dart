import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import '../../data/test_data.dart' as data;

@CustomTag('autocomplete-demo')
class AutocompleteDemo extends PolymerElement {
  
  @observable List<data.Player> players = toObservable(data.players);
  @observable List<String> playerNames = toObservable(data.playerNames);
  
  bool get applyAuthorStyles => true;
  
  AutocompleteDemo.created() : super.created();
  
  void onValueChangedFired(Event event, var detail, Element target) {
    GrowlComponent.postMessage('Value changed:', target.value);
  }
  
}