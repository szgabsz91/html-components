import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show ContextMenuComponent, GrowlComponent;

@CustomTag('context-menu-demo')
class ContextMenuDemo extends ShowcaseItem {
  
  ContextMenuDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/menu/context-menu.html', 'demo/menu/context-menu.dart']);
  }
  
  void onMenuItemSelected(CustomEvent event, var detail, ContextMenuComponent target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}