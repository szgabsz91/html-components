import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('context-menu-demo')
class ContextMenuDemo extends PolymerElement {
  
  @observable bool disabled = false;
  
  ContextMenuDemo.created() : super.created();
  
  void onMenuItemSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}