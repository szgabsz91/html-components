import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show SelectItemModel, SelectCheckboxMenuComponent, GrowlComponent;
import '../../data/select_item.dart' as data;

@CustomTag('select-checkbox-menu-demo')
class SelectCheckboxMenuDemo extends ShowcaseItem with data.SelectItemConverter {
  
  SelectCheckboxMenuDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/input/select-checkbox-menu.html', 'demo/input/select-checkbox-menu.dart', 'data/select_item.dart']);
  }
  
  void onSelectionChangedFired(Event event, var detail, SelectCheckboxMenuComponent target) {
    GrowlComponent.postMessage('Selection changed:', selectItemsToString(target.selectedItems));
  }
  
}