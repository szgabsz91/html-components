import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import '../../data/test_data.dart' as data;

@CustomTag('treetable-demo')
class TreetableDemo extends PolymerElement {
  
  @observable TreeNode documentRoot = data.getDocumentRoot();
  
  bool get applyAuthorStyles => true;
  
  TreetableDemo.created() : super.created();
  
  void onItemExpanded(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Expanded:', _detailToString(detail));
  }
  
  void onItemCollapsed(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Collapsed:', _detailToString(detail));
  }
  
  void onItemSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected:', _detailToString(detail));
  }
  
  void onColumnResized(Event event) {
    GrowlComponent.postMessage('', 'Column resized!');
  }
  
  String _detailToString(var detail) {
    if (detail is Map) {
      return detail['name'];
    }
    
    return detail.name;
  }
  
}