import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('picklist-demo')
class PicklistDemo extends ShowcaseCollection {
  
  PicklistDemo.created() : super.created() {
    super.hashPrefix = '/data/picklist';
    super.items = [
      new ItemModel('Strings', 'strings'),
      new ItemModel('Objects', 'objects')
    ];
  }
  
}