import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-menu-item')
class MenuItemComponent extends PolymerElement {
  
  @published String url = '#';
  @published String icon;
  @published String target = '_self';
  
  bool get _isExternal => url != '#';
  
  MenuItemComponent.created() : super.created();
  
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
    
    String label = $['text'].querySelector('content').getDistributedNodes().first.text;
    
    this.dispatchEvent(new CustomEvent('selected', detail: label));
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