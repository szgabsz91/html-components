import 'package:polymer/polymer.dart';

class TreeNodeModel extends Object with Observable {
  
  @observable String type;
  @observable String icon;
  @observable String collapsedIcon;
  @observable String expandedIcon;
  
  TreeNodeModel(this.type, this.icon, this.collapsedIcon, this.expandedIcon);
  
}