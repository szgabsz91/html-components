import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show AutocompleteComponent, GrowlComponent;

@CustomTag('autocomplete-server-demo')
class AutocompleteServerDemo extends ShowcaseItem {
  
  AutocompleteServerDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/input/autocomplete/server.html', 'demo/input/autocomplete/server.dart']);
  }
  
  void onValueChangedFired(Event event, var detail, AutocompleteComponent target) {
    GrowlComponent.postMessage('Value changed:', target.value);
  }
  
}