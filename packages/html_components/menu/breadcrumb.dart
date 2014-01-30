import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'menu_item.dart';

@CustomTag('h-breadcrumb')
class BreadcrumbComponent extends PolymerElement {
  
  BreadcrumbComponent.created() : super.created() {
    _startInitialization();
  }
  
  void _startInitialization() {
    new Timer(const Duration(milliseconds: 100), _init);
  }
  
  void _init() {
    if ($['hidden'] == null) {
      return;
    }
    
    ContentElement contentElement = $['hidden'].querySelector('content');
    List<MenuItemComponent> menuItems = contentElement.getDistributedNodes();
    
    if (menuItems.isEmpty) {
      _startInitialization();
    }
    
    for (int i = 0; i < menuItems.length; i++) {
      MenuItemComponent menuItem = menuItems[i];
      
      menuItem.setMenubarOrientation('horizontal');
      $['list'].children.add(menuItem);
      
      // In Chrome the selected event isn't propagated
      menuItem.on['selected'].listen((CustomEvent event) {
        event.preventDefault();
        event.stopPropagation();
        event.stopImmediatePropagation();
        
        this.dispatchEvent(new CustomEvent('selected', detail: event.detail));
      });
      
      if (i < menuItems.length - 1) {
        LIElement separatorElement = new LIElement()..classes.add('separator');
        $['list'].children.add(separatorElement);
      }
    }
    
    $['hidden'].remove();
  }
  
}