import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show SelectItemModel, SelectButtonComponent, GrowlComponent;
import '../../data/select_item.dart' as data;

@CustomTag('select-button-demo')
class SelectButtonDemo extends ShowcaseItem with data.SelectItemConverter {
  
  @observable String selection = 'single';
  
  SelectButtonDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/input/select-button.html', 'demo/input/select-button.dart', 'data/select_item.dart']);
  }
  
  void onSelectionChangedFired(Event event, var detail, SelectButtonComponent target) {
    GrowlComponent.postMessage('Selection changed:', selectItemsToString(target.selectedItems));
  }
  
}