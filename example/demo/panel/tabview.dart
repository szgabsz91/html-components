import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('tabview-demo')
class TabviewDemo extends ShowcaseCollection {
  
  TabviewDemo.created() : super.created() {
    super.hashPrefix = '/panel/tabview';
    super.items = [
      new ItemModel('Dynamic Tabs', 'dynamic'),
      new ItemModel('Static Tabs', 'static')
    ];
  }
  
}