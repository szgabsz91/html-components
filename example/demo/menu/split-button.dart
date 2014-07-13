import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show SplitButtonComponent, GrowlComponent;

@CustomTag('split-button-demo')
class SplitButtonDemo extends ShowcaseItem {
  
  SplitButtonDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/menu/split-button.html', 'demo/menu/split-button.dart']);
  }
  
  void onMenuItemSelected(CustomEvent event, var detail, SplitButtonComponent target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}