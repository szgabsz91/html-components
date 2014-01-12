import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart' as animation;
import 'tab.dart';

@CustomTag('h-accordion')
class AccordionComponent extends PolymerElement {
  
  @published String selection = 'single';
  @observable List<TabModel> tabs = toObservable([]);
  
  AccordionComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    Timer.run(() {
      ContentElement content = $['hidden'].querySelector('content');
      List tabComponents = content.getDistributedNodes();
      tabs = toObservable(
        tabComponents
          .where((Node node) => node is TabComponent)
          .map((TabComponent component) => component.model)
          .toList(growable: false)
      );
      $['hidden'].children.clear();
      
      _selectFirstTab();
    });
  }
  
  void onHeaderMouseOver(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    TabModel tab = tabs[((target.parent.children.indexOf(target) - 1) / 2).floor()];
    
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
    
    int tabHeaderIndex = ((target.parent.children.indexOf(target) - 1) / 2).floor();
    int tabContentIndex = target.parent.children.indexOf(target) + 1;
    
    TabModel tab = tabs[tabHeaderIndex];
    DivElement tabContent = target.parent.children[tabContentIndex];
    
    if (tab.disabled) {
      return;
    }
    
    if (tab.selected) {
      _closeTab(tabContent, tab);
    }
    else {
      if (selection == 'single') {
        for (int i = 0; i < tabs.length; i++) {
          if (tabs[i].selected) {
            _closeTab(target.parent.children[(i + 1) * 2], tabs[i]);
          }
        }
      }
      
      _openTab(tabContent, tab);
    }
  }
  
  void _openTab(DivElement tabContent, TabModel tab) {
    _getTabHeight(tabContent).then((int height) {
      Map<String, Object> animationProperties = {
        'height': height,
        'padding-top': 5,
        'padding-bottom': 5
      };
      
      animation.animate(tabContent, properties: animationProperties, duration: 500).onComplete.listen((_) {
        tab.selected = true;
        this.dispatchEvent(new CustomEvent('selected', detail: tab));
      });
    });
  }
  
  void _closeTab(DivElement tabContent, TabModel tab) {
    Map<String, Object> animationProperties = {
      'height': 0,
      'padding-top': 0,
      'padding-bottom': 0
    };
    
    animation.animate(tabContent, properties: animationProperties, duration: 500).onComplete.listen((_) {
      tab.selected = false;
      this.dispatchEvent(new CustomEvent('deselected', detail: tab));
    });
  }
  
  Future<int> _getTabHeight(DivElement div) {
    Completer completer = new Completer();
    
    $['hidden'].style.display = 'block';
    DivElement clone = div.clone(true);
    clone.classes.remove('hidden');
    clone.style.height = 'auto';
    $['hidden'].children.add(clone);
    
    new Future.delayed(new Duration(milliseconds: 50), () {
      completer.complete($['hidden'].clientHeight);
      clone.remove();
      $['hidden'].style.display = 'none';
    });
    
    return completer.future;
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