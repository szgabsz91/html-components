import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'tab.dart';

@CustomTag('h-tabview')
class TabviewComponent extends PolymerElement {
  
  @published String orientation = 'top';
  @observable List<TabModel> tabs = toObservable([]);
  
  TabviewComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    scheduleMicrotask(() {
      ContentElement content = $['hidden'].querySelector('content');
      List tabComponents = content.getDistributedNodes();
      tabs = toObservable(
        tabComponents
          .where((Node node) => node is TabComponent)
          .map((TabComponent component) => component.model)
          .toList(growable: false)
      );
      $['hidden'].remove();
      
      _selectFirstTab();
    });
  }
  
  void orientationChanged() {
    $['container'].classes
      ..removeAll(['top', 'bottom', 'left', 'right'])
      ..add(orientation);
  }
  
  void onHeaderMouseOver(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    TabModel tab = tabs[target.parent.children.indexOf(target) - 1];
    
    if (tab.selected || tab.disabled || tab.closed) {
      return;
    }
    
    target.classes.add('hover');
  }
  
  void onHeaderMouseOut(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    target.classes.remove('hover');
  }
  
  void onHeaderClicked(MouseEvent event, var detail, Node target) {
    event.preventDefault();
    
    TabModel tab = tabs[target.parent.children.indexOf(target) - 1];
    
    if (tab.selected || tab.disabled) {
      return;
    }
    
    tabs.forEach((TabModel tab) => tab.selected = false);
    tab.selected = true;
    
    this.dispatchEvent(new CustomEvent('tabselected', detail: tab));
  }
  
  void onCloseThickClicked(MouseEvent event, var detail, Node target) {
    event.preventDefault();
    
    TabModel tab = tabs[target.parent.parent.children.indexOf(target.parent) - 1];
    
    if (tab.disabled) {
      return;
    }
    
    tabs.remove(tab);
    
    if (tab.selected) {
      _selectFirstTab();
    }
    
    this.dispatchEvent(new CustomEvent('tabclosed', detail: tab));
  }
  
  void _selectFirstTab() {
    if (tabs.any((TabModel tab) => tab.selected)) {
      return;
    }
    
    TabModel tab = tabs.firstWhere((TabModel tabModel) => !tabModel.disabled, orElse: () => null);
    
    if (tab != null) {
      tab.selected = true;
    }
  }
  
}