import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show BreadcrumbComponent, GrowlComponent;

@CustomTag('breadcrumb-demo')
class BreadcrumbDemo extends ShowcaseItem {
  
  BreadcrumbDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/menu/breadcrumb.html', 'demo/menu/breadcrumb.dart']);
  }
  
  void onMenuItemSelected(CustomEvent event, var detail, BreadcrumbComponent target) {
    GrowlComponent.postMessage('Selected menu item:', detail);
  }
  
}