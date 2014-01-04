import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

String selectedItemsToString(List<SelectItemModel> selectedItems) {
  if (selectedItems.isEmpty) {
    return 'none';
  }
  
  StringBuffer resultBuffer = new StringBuffer();
  
  for (SelectItemModel selectedItem in selectedItems) {
    resultBuffer.write('${selectedItem.label}, ');
  }
  
  String result = resultBuffer.toString();
  
  if (result.length > 0) {
    return result.substring(0, result.length - 2);
  }
  
  return result;
}

void main() {
  initPolymer();
  
  querySelectorAll('h-select-checkbox-menu').forEach((SelectCheckboxMenuComponent selectCheckboxMenu) {
    selectCheckboxMenu.on['selectionChanged'].listen((Event event) {
      print('selection changed: ${selectedItemsToString(selectCheckboxMenu.selectedItems)}');
    });
  });
}