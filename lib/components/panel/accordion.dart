library accordion;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "tab.dart";
import "package:animation/animation.dart" as animation;
import "../common/templates.dart";

part "accordion/model.dart";

class AccordionComponent extends WebComponent implements TabListener {
  AccordionModel model = new AccordionModel();
  
  DivElement get _hiddenArea => this.query(".x-accordion_ui-helper-hidden");
  List<DivElement> get _tabComponents => _hiddenArea.queryAll('div[is="x-tab"]');
  DivElement get _hiddenDiv => _hiddenArea.query("div");
  DivElement get _tabContainer => this.query(".x-accordion_ui-accordion");
  DivElement _getTabByIndex(int index) {
    return _tabContainer.queryAll(".x-accordion_ui-accordion-content")
                        .elementAt(index);
  }
  HeadingElement _getTabHeaderByIndex(int index) {
    return _tabContainer.queryAll(".x-accordion_ui-accordion-header")
                        .elementAt(index);
  }
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("selected", detail: label));
  }
  
  static const EventStreamProvider<CustomEvent> _DESELECTED_EVENT = const EventStreamProvider<CustomEvent>("deselected");
  Stream<CustomEvent> get onDeselected => _DESELECTED_EVENT.forTarget(this);
  static _dispatchDeselectedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("deselected", detail: label));
  }
  
  void inserted() {
    _initSimple();
  }
  
  String get selection => model.selection;
  set selection(String selection) => model.selection = selection;
  
  List<Object> get data => model.data;
  set data(List<Object> data) {
    model.data = data;
    _initCustomModel();
  }
  
  void onTabSelected(TabModel tab) {
    int index = model.tabs.indexOf(tab);
    DivElement tabElement = _getTabByIndex(index);
    HeadingElement headerElement = _getTabHeaderByIndex(index);
    
    _getTabHeight(tabElement).then((int height) {
      Map<String, Object> animationProperties = {
        "height": height,
        "padding-top": 5,
        "padding-bottom": 5
      };
      
      tab.selected = true;
      headerElement.classes.remove("x-accordion_ui-state-hover");
      
      animation.animate(tabElement, properties: animationProperties, duration: 500).onComplete.listen((_) {
        tabElement.classes.remove("x-accordion_hidden-tab");
      });
    }).catchError((Object error) => print("An error occured: $error"));
  }
  
  void onTabDeselected(TabModel tab) {
    int index = model.tabs.indexOf(tab);
    DivElement tabElement = _getTabByIndex(index);
    
    Map<String, Object> animationProperties = {
      "height": 0,
      "padding-top": 0,
      "padding-bottom": 0
    };
    
    animation.animate(tabElement, properties: animationProperties, duration: 500);
  }
  
  void onTabClosed(TabModel tab) {
    // Tabs cannot be closed inside an accordion
  }
  
  void _onMouseOver(TabModel tab) {
    if (tab.selected || tab.disabled) {
      return;
    }
    
    int index = model.tabs.indexOf(tab);
    HeadingElement headerElement = _getTabHeaderByIndex(index);
    headerElement.classes.add("x-accordion_ui-state-hover");
  }
  
  void _onMouseOut(TabModel tab) {
    if (tab.selected || tab.disabled) {
      return;
    }
    
    int index = model.tabs.indexOf(tab);
    HeadingElement headerElement = _getTabHeaderByIndex(index);
    headerElement.classes.remove("x-accordion_ui-state-hover");
  }
  
  void _onClicked(TabModel tab, MouseEvent event) {
    event.preventDefault();
    
    if (tab.disabled) {
      return;
    }
    
    if (tab.selected) {
      tab.deselect();
      _dispatchDeselectedEvent(this, tab.label);
    }
    else {
      if (model.selection == "single") {
        model.tabs.forEach((TabModel tab) => tab.deselect());
      }
      
      tab.select();
      _dispatchSelectedEvent(this, tab.label);
    }
  }
  
  Future<int> _getTabHeight(DivElement div) {
    Completer completer = new Completer();
    
    _hiddenArea.style.display = "block";
    DivElement clone = div.clone(true);
    clone.classes.remove("x-accordion_hidden-tab");
    clone.style.height = "auto";
    _hiddenArea.children.add(clone);
    
    new Future.delayed(new Duration(milliseconds: 50), () {
      completer.complete(_hiddenDiv.clientHeight);
      clone.remove();
      _hiddenArea.style.display = "none";
    });
    
    return completer.future;
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