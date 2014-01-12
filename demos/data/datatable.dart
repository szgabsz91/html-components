import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import '../../data/test_data.dart' as data;

@CustomTag('datatable-demo')
class DatatableDemo extends PolymerElement {
  
  @observable List<data.Car> cars = toObservable(data.cars); 
  
  bool get applyAuthorStyles => true;
  
  DatatableDemo.created() : super.created();
  
  void onColumnSorted(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Sorted column:', detail);
  }
  
  void onColumnFiltered(Event event, var detail, Element target) {
    GrowlComponent.postMessage('', 'Column filtered!');
  }
  
  void onItemSelected(Event event, var detail, Element target) {
    GrowlComponent.postMessage('Selected items:', selectedItemsToString(target.selectedItems));
  }
  
  void onItemEdited(Event event, var detail, Element target) {
    GrowlComponent.postMessage('', 'Item edited!');
  }
  
  void onColumnResized(Event event, var detail, Element target) {
    GrowlComponent.postMessage('', 'Column resized!');
  }
  
  void onRowToggled(Event event, var detail, Element target) {
    GrowlComponent.postMessage('', 'Row toggled!');
  }
  
  String selectedItemsToString(var selectedItems) {
    if (selectedItems.isEmpty) {
      return 'none';
    }
    
    StringBuffer resultBuffer = new StringBuffer();
    
    // Exception: type 'SelectItemModel' is not a subtype of type 'SelectItemModel' of 'selectedItem'.
    for (var selectedItem in selectedItems) {
      resultBuffer.write('${selectedItem.model}, ');
    }
    
    String result = resultBuffer.toString();
    
    if (result.length > 0) {
      return result.substring(0, result.length - 2);
    }
    
    return result;
  }
  
}