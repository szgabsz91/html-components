import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatatableComponent, GrowlComponent;

@CustomTag('datatable-server-demo')
class DatatableServerDemo extends ShowcaseItem {
  
  DatatableServerDemo.created() : super.created() {
    super.noscript = true;
    super.setCodeSamples(const ['demo/data/datatable/server.html']);
  }
  
}