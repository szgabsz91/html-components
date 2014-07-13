import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('tree-demo')
class TreeDemo extends ShowcaseCollection {
  
  TreeDemo.created() : super.created() {
    super.hashPrefix = '/data/tree';
    super.items = [
      new ItemModel('Client Data', 'client'),
      new ItemModel('Icons', 'icons'),
      new ItemModel('Server Data', 'server')
    ];
  }
  
}