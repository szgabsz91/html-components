import 'package:polymer/polymer.dart';
import 'tree_node/model.dart';

export 'tree_node/model.dart';

@CustomTag('h-tree-node')
class TreeNodeComponent extends PolymerElement {
  
  @published String type;
  @published String icon;
  @published String collapsedIcon;
  @published String expandedIcon;
  
  TreeNodeComponent.created() : super.created();
  
  TreeNodeModel get model => new TreeNodeModel(type, icon, collapsedIcon, expandedIcon);
  
}