import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'tab.dart';

@CustomTag('h-accordion')
class AccordionComponent extends PolymerElement {
  
  @published String selection = 'single';
  @observable List<TabModel> tabs = toObservable([]);
  
  AccordionComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
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
    Element tabContentTemplate = tabContent.children[0].shadowRoot.children[0];
    
    if (tab.disabled) {
      return;
    }
    
    if (tab.selected) {
      _closeTab(tabContent, tabContentTemplate, tab);
    }
    else {
      if (selection == 'single') {
        for (int i = 0; i < tabs.length; i++) {
          if (tabs[i].selected) {
            _closeTab(target.parent.children[(i + 1) * 2], target.parent.children[(i + 1) * 2].children[0].shadowRoot.children[0], tabs[i]);
          }
        }
      }
      
      _openTab(tabContent, tabContentTemplate, tab);
    }
  }
  
  void _openTab(DivElement tabContent, Element tabContentTemplate, TabModel tab) {
    _getTabHeight(tabContentTemplate, $['hidden']).then((int height) {
      tabContent.style
        ..maxHeight = '${height}px'
        ..paddingTop = '5px'
        ..paddingBottom = '5px';
      new Timer(const Duration(milliseconds: 500), () {
        tab.selected = true;
        this.dispatchEvent(new CustomEvent('selected', detail: tab));
      });
    });
  }
  
  void _closeTab(DivElement tabContent, Element tabContentTemplate, TabModel tab) {
    _getTabHeight(tabContentTemplate, $['hidden2']).then((int height) {
      tabContent.style.maxHeight = '${height}px';
      new Timer(const Duration(milliseconds: 50), () {
        tabContent.style
          ..maxHeight = '0'
          ..paddingTop = '0'
          ..paddingBottom = '0';
        new Timer(const Duration(milliseconds: 500), () {
          tab.selected = false;
          this.dispatchEvent(new CustomEvent('deselected', detail: tab));
        });
      });
    });
  }
  
  Future<int> _getTabHeight(Element div, DivElement hiddenElement) {
    Completer completer = new Completer();
    
    hiddenElement.style.display = 'block';
    Element clone = div.clone(true);
    clone.classes.remove('hidden');
    clone.style.height = 'auto';
    hiddenElement.children.add(clone);
    
    new Future.delayed(new Duration(milliseconds: 50), () {
      completer.complete(hiddenElement.clientHeight);
      clone.remove();
      hiddenElement.style.display = 'none';
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