import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('treetable-demo')
class TreetableDemo extends ShowcaseCollection {
  
  TreetableDemo.created() : super.created() {
    super.hashPrefix = '/data/treetable';
    super.items = [
      new ItemModel('Client Data', 'client'),
      new ItemModel('Server Data', 'server')
    ];
  }
  
}