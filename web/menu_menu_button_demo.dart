import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('menu-button-demo')
class MenuButtonDemo extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  MenuButtonDemo.created() : super.created();
  
  void onMenuItemSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}