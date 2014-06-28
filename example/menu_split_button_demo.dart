import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('split-button-demo')
class SplitButtonDemo extends PolymerElement {
  
  SplitButtonDemo.created() : super.created();
  
  void onMenuItemSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}