import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import 'selected_items_converter.dart';

@CustomTag('select-button-demo')
class SelectButtonDemo extends PolymerElement with SelectedItemsConverter {
  
  bool get applyAuthorStyles => true;
  
  SelectButtonDemo.created() : super.created();
  
  void onSelectionChangedFired(Event event, var detail, Element target) {
    GrowlComponent.postMessage('Selection changed:', selectedItemsToString(target.selectedItems));
  }
  
}