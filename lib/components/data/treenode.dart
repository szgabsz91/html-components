library treenode;

import "package:web_ui/web_ui.dart";

part "treenode/model.dart";

class TreeNodeComponent extends WebComponent {
  TreeNodeModel _model = new TreeNodeModel();
  
  TreeNodeModel get model => _model;
  
  String get type => model.type;
  set type(String type) => model.type = type;
  
  String get icon => model.icon;
  set icon(String icon) => model.icon = icon;
  
  String get collapsedicon => model.collapsedIcon;
  set collapsedicon(String collapsedicon) => model.collapsedIcon = collapsedicon;
  
  String get expandedicon => model.expandedIcon;
  set expandedicon(String expandedicon) => model.expandedIcon = expandedicon;
}