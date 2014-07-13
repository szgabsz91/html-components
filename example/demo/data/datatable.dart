import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('datatable-demo')
class DatatableDemo extends ShowcaseCollection {
  
  DatatableDemo.created() : super.created() {
    super.hashPrefix = '/data/datatable';
    super.items = [
      new ItemModel('Selection', 'selection'),
      new ItemModel('Sort', 'sort'),
      new ItemModel('Filter', 'filter'),
      new ItemModel('Edit', 'edit'),
      new ItemModel('Expansion Row', 'expansion-row'),
      new ItemModel('Resizable Column', 'resizable-column'),
      new ItemModel('Server Data', 'server')
    ];
  }
  
}