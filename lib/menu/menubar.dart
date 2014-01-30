import 'package:polymer/polymer.dart';
import 'dart:html';
import 'menu_item.dart';
import 'submenu.dart';

@CustomTag('h-menubar')
class MenubarComponent extends PolymerElement {
  
  @published String orientation = 'horizontal';
  
  MenubarComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    orientationChanged();
  }
  
  void orientationChanged() {
    ContentElement contentElement = $['menubar-container'].querySelector('ul content');
    List children = contentElement.getDistributedNodes().where((Node node) => node is MenuItemComponent || node is SubmenuComponent).toList(growable: false);
    
    if (orientation == 'horizontal') {
      children.forEach((var child) => child.setMenubarOrientation('horizontal'));
    }
    else {
      children.forEach((var child) => child.setMenubarOrientation('vertical'));
    }
  }
  
}