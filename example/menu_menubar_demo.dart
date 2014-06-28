import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('menubar-demo')
class MenubarDemo extends PolymerElement {
  
  @observable String orientation = 'horizontal';
  
  MenubarDemo.created() : super.created();
  
  void onMenuItemSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}