import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show TreetableComponent, GrowlComponent;
import '../../../data/tree_nodes.dart' as data;

@CustomTag('treetable-server-demo')
class TreetableServerDemo extends ShowcaseItem with data.TreeNodeConverter {
  
  @observable String selection = 'single';
  
  TreetableServerDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/treetable/server.html', 'demo/data/treetable/server.dart', 'data/tree_nodes.dart']);
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
  
  void onColumnResized(Event event, var detail, TreetableComponent target) {
    GrowlComponent.postMessage('', 'Column resized!');
  }
  
}