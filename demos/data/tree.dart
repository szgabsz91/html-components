import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import '../../data/test_data.dart' as data;

@CustomTag('tree-demo')
class TreeDemo extends PolymerElement {
  
  @observable TreeNode stringRoot = data.getStringRoot();
  @observable TreeNode documentRoot = data.getDocumentRoot();
  
  bool get applyAuthorStyles => true;
  
  TreeDemo.created() : super.created();
  
  void onItemExpanded(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Expanded:', _detailToString(detail));
  }
  
  void onItemCollapsed(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Collapsed:', _detailToString(detail));
  }
  
  void onItemSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected:', _detailToString(detail));
  }
  
  void onItemDeselected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Deselected:', _detailToString(detail));
  }
  
  String _detailToString(var detail) {
    if (detail is String) {
      return detail;
    }
    
    if (detail is Map) {
      return detail['name'];
    }
    
    return detail.name;
  }
  
}