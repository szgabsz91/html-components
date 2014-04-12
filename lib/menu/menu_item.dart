import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-menu-item')
class MenuItemComponent extends PolymerElement {
  
  @published String url = '#';
  @published String icon;
  @published String label;
  @published String target = '_self';
  
  bool get _isExternal => url != '#';
  
  MenuItemComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    ContentElement contentElement = $['hidden'].querySelector('content');
    List children = contentElement.getDistributedNodes();
    
    this.label = children.first.text.toString();
    
    $['hidden'].remove();
  }
  
  void onItemMouseOver() {
    $['link'].classes.add('hover');
  }
  
  void onItemMouseOut() {
    $['link'].classes.remove('hover');
  }
  
  void onItemClicked(MouseEvent event) {
    if (!_isExternal) {
      event.preventDefault();
    }
    
    this.dispatchEvent(new CustomEvent('selected', detail: this.label));
  }
  
  void setMenubarOrientation(String orientation) {
    if (orientation == 'horizontal') {
      $['link'].style.width = 'auto';
      this.style.float = 'left';
    }
    else if (orientation == 'vertical') {
      $['link'].style.width = null;
      this.style.float = null;
    }
  }
  
}