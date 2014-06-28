import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('select-checkbox-menu-demo')
class SelectCheckboxMenuDemo extends PolymerElement {
  
  SelectCheckboxMenuDemo.created() : super.created();
  
  void onSelectionChangedFired(Event event, var detail, SelectCheckboxMenuComponent target) {
    GrowlComponent.postMessage('Selection changed:', selectedItemsToString(target.selectedItems));
  }
  
  // Exception: type 'SelectItemModel' is not a subtype of type 'SelectItemModel' of 'selectedItem'.
  String selectedItemsToString(var selectedItems) {
    if (selectedItems.isEmpty) {
      return 'none';
    }
    
    StringBuffer resultBuffer = new StringBuffer();
    
    // Exception: type 'SelectItemModel' is not a subtype of type 'SelectItemModel' of 'selectedItem'.
    for (var selectedItem in selectedItems) {
      resultBuffer.write('${selectedItem.label}, ');
    }
    
    String result = resultBuffer.toString();
    
    if (result.length > 0) {
      return result.substring(0, result.length - 2);
    }
    
    return result;
  }
  
}