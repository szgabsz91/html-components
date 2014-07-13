import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('listbox-demo')
class ListboxDemo extends ShowcaseCollection {
  
  ListboxDemo.created() : super.created() {
    super.hashPrefix = '/data/listbox';
    super.items = [
      new ItemModel('Strings', 'strings'),
      new ItemModel('Objects', 'objects')
    ];
  }
  
}