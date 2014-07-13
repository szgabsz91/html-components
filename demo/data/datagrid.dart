import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('datagrid-demo')
class DatagridDemo extends ShowcaseCollection {
  
  DatagridDemo.created() : super.created() {
    super.hashPrefix = '/data/datagrid';
    super.items = [
      new ItemModel('Client Data', 'client'),
      new ItemModel('Server Data', 'server')
    ];
  }
  
}