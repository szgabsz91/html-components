import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show AutocompleteComponent, GrowlComponent;
import '../../../data/player.dart' as data;

@CustomTag('autocomplete-client-demo')
class AutocompleteClientDemo extends ShowcaseItem {
  
  @observable List<data.Player> players = toObservable(data.players);
  @observable List<String> playerNames = toObservable(data.playerNames);
  
  AutocompleteClientDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/input/autocomplete/client.html', 'demo/input/autocomplete/client.dart', 'data/player.dart']);
  }
  
  void onValueChangedFired(Event event, var detail, AutocompleteComponent target) {
    GrowlComponent.postMessage('Value changed:', target.value);
  }
  
}