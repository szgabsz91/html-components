import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('autocomplete-demo')
class AutocompleteDemo extends ShowcaseCollection {
  
  AutocompleteDemo.created() : super.created() {
    super.hashPrefix = '/input/autocomplete';
    super.items = [
      new ItemModel('Client Data', 'client'),
      new ItemModel('Server Data', 'server')
    ];
  }
  
}