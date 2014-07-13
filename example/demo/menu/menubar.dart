import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show MenubarComponent, GrowlComponent;

@CustomTag('menubar-demo')
class MenubarDemo extends ShowcaseItem {
  
  @observable String orientation = 'horizontal';
  
  MenubarDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/menu/menubar.html', 'demo/menu/menubar.dart']);
  }
  
  void onMenuItemSelected(CustomEvent event, var detail, MenubarComponent target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}