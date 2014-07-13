import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show TreeComponent, GrowlComponent;
import '../../../data/tree_nodes.dart' as data;

@CustomTag('tree-server-demo')
class TreeServerDemo extends ShowcaseItem with data.TreeNodeConverter {
  
  @observable String selection = 'single';
  @observable bool animating = true;
  
  TreeServerDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/tree/server.html', 'demo/data/tree/server.dart', 'data/tree_nodes.dart']);
  }
  
  void onItemExpanded(CustomEvent event, var detail, TreeComponent target) {
    GrowlComponent.postMessage('Expanded:', treeNodeToString(detail));
  }
  
  void onItemCollapsed(CustomEvent event, var detail, TreeComponent target) {
    GrowlComponent.postMessage('Collapsed:', treeNodeToString(detail));
  }
  
  void onItemSelected(CustomEvent event, var detail, TreeComponent target) {
    GrowlComponent.postMessage('Selected:', treeNodeToString(detail));
  }
  
  void onItemDeselected(CustomEvent event, var detail, TreeComponent target) {
    GrowlComponent.postMessage('Deselected:', treeNodeToString(detail));
  }
  
}