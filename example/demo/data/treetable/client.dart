import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show TreeNode, TreetableComponent, GrowlComponent;
import '../../../data/tree_nodes.dart' as data;

@CustomTag('treetable-client-demo')
class TreetableClientDemo extends ShowcaseItem with data.TreeNodeConverter {
  
  @observable TreeNode root = data.documentRoot;
  @observable String selection = 'single';
  
  TreetableClientDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/treetable/client.html', 'demo/data/treetable/client.dart', 'data/tree_nodes.dart']);
  }
  
  void onItemExpanded(CustomEvent event, var detail, TreetableComponent target) {
    GrowlComponent.postMessage('Expanded:', treeNodeToString(detail));
  }
  
  void onItemCollapsed(CustomEvent event, var detail, TreetableComponent target) {
    GrowlComponent.postMessage('Collapsed:', treeNodeToString(detail));
  }
  
  void onItemSelected(CustomEvent event, var detail, TreetableComponent target) {
    GrowlComponent.postMessage('Selected:', treeNodeToString(detail));
  }
  
}