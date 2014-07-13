import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show MenuButtonComponent, GrowlComponent;

@CustomTag('menu-button-demo')
class MenuButtonDemo extends ShowcaseItem {
  
  MenuButtonDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/menu/menu-button.html', 'demo/menu/menu-button.dart']);
  }
  
  void onMenuItemSelected(CustomEvent event, var detail, MenuButtonComponent target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}