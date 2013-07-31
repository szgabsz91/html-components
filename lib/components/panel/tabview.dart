library tabview;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "tab.dart";
import "../common/templates.dart";

part "tabview/model.dart";

class TabviewComponent extends WebComponent implements TabListener {
  TabviewModel model = new TabviewModel();
  
  DivElement get _hiddenArea => this.query(".x-tabview_ui-helper-hidden");
  List<DivElement> get _tabComponents => _hiddenArea.queryAll('div[is="x-tab"]');
  UListElement get _headerContainer => this.query(".x-tabview_ui-tabs-nav");
  LIElement _getTabHeaderByIndex(int index) {
    return _headerContainer.queryAll("li")
                           .elementAt(index);
  }
  DivElement get _tabContainer => this.query(".x-tabview_ui-tabs-panels");
  DivElement _getTabByIndex(int index) {
    return _tabContainer.queryAll(".x-tabview_ui-tabs-panel")
                        .elementAt(index);
  }
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("selected", detail: label));
  }
  
  static const EventStreamProvider<CustomEvent> _CLOSED_EVENT = const EventStreamProvider<CustomEvent>("closed");
  Stream<CustomEvent> get onClosed => _CLOSED_EVENT.forTarget(this);
  static _dispatchClosedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("closed", detail: label));
  }
  
  void inserted() {
    _initSimple();
  }
  
  String get orientation => model.orientation;
  set orientation(String orientation) => model.orientation = orientation;
  
  List<Object> get data => model.data;
  set data(List<Object> data) {
    model.data = data;
    
    if (data != null) {
      _initCustomModel();
    }
    else {
      _initSimple();
    }
  }
  
  void onTabSelected(TabModel tab) {
    int index = model.tabs.indexOf(tab);
    DivElement tabElement = _getTabByIndex(index);
    LIElement headerElement = _getTabHeaderByIndex(index);
    
    tab.selected = true;
    headerElement.classes.remove("x-tabview_ui-state-hover");
  }
  
  void onTabDeselected(TabModel tab) {
    // Nothing happens if a tab gets deselected
  }
  
  void onTabClosed(TabModel tab) {
    model.tabs.remove(tab);
    
    if (tab.selected) {
      _selectFirstTab();
    }
  }
  
  void _onMouseOver(TabModel tab) {
    if (tab.selected || tab.disabled || tab.closed) {
      return;
    }
    
    int index = model.tabs.indexOf(tab);
    LIElement headerElement = _getTabHeaderByIndex(index);
    headerElement.classes.add("x-tabview_ui-state-hover");
  }
  
  void _onMouseOut(TabModel tab) {
    if (tab.selected || tab.disabled || tab.closed) {
      return;
    }
    
    int index = model.tabs.indexOf(tab);
    LIElement headerElement = _getTabHeaderByIndex(index);
    headerElement.classes.remove("x-tabview_ui-state-hover");
  }
  
  void _onClicked(TabModel tab, MouseEvent event) {
    if (event.target is SpanElement) {
      return;
    }
    
    event.preventDefault();
    
    if (tab.disabled) {
      return;
    }
    
    model.tabs.forEach((TabModel tab) => tab.deselect());
    
    tab.select();
    
    _dispatchSelectedEvent(this, tab.label);
  }
  
  void _onCloseClicked(TabModel tab, MouseEvent event) {
    event.preventDefault();
    
    if (tab.disabled || tab.closed) {
      return;
    }
    
    tab.close();
    
    _dispatchClosedEvent(this, tab.label);
  }
  
  void _initSimple() {
    if (model.tabs.isEmpty && _tabComponents != null) {
      _tabComponents.forEach((Element element) {
        TabComponent tabComponent = element.xtag;
        TabModel tabModel = tabComponent.model;
        model.tabs.add(tabModel);
        tabModel.addListener(this);
      });
      
      _hiddenArea.children.clear();
    }
    
    _selectFirstTab();
  }
  
  void _initCustomModel() {
    if (model.data == null || model.tabs.isEmpty) {
      return;
    }
    
    TabModel firstTab = model.tabs.first;
    
    TemplateManager labelTemplateManager = new TemplateManager(firstTab.label);
    TemplateManager contentTemplateManager = new TemplateManager(firstTab.content.toString());
    
    model.tabs.clear();
    
    model.data.forEach((Object item) {
      TabModel tabModel = new TabModel();
      
      tabModel
        ..label = labelTemplateManager.getSubstitutedString(item)
        ..content = contentTemplateManager.getSubstitutedString(item);
      
      model.tabs.add(tabModel);
      tabModel.listeners.add(this);
    });
    
    _selectFirstTab();
  }
  
  void _selectFirstTab() {
    if (model.tabs.any((TabModel tab) => tab.selected)) {
      return;
    }
    
    TabModel tab = model.tabs.firstWhere((TabModel tabModel) => !tabModel.disabled, orElse: () => null);
    
    if (tab != null) {
      tab.selected = true;
    }
  }
}