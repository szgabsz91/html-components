import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('accordion-demo')
class AccordionDemo extends ShowcaseCollection {
  
  AccordionDemo.created() : super.created() {
    super.hashPrefix = '/panel/accordion';
    super.items = [
      new ItemModel('Dynamic Tabs', 'dynamic'),
      new ItemModel('Static Tabs', 'static')
    ];
  }
  
}