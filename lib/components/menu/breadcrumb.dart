library breadcrumb;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "common/menu.dart";
import "menuitem.dart";

class BreadcrumbComponent extends WebComponent {
  
  UListElement get _itemContainer => this.query("ul");
  List<LIElement> get _menuItemElements => this.queryAll('li[is="x-menuitem"]');
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element, String label) {
    SelectEventDetail detail = new SelectEventDetail(label);
    element.dispatchEvent(new CustomEvent("selected", detail: detail.toString()));
  }
  
  void inserted() {
    int itemCount = _itemContainer.children.length;
    
    for (int index = 0; index < 2 * itemCount; index += 2) {
      LIElement separatorElement = _getSeparatorElement();
      _itemContainer.children.insert(index, separatorElement);
    }
    
    _menuItemElements.forEach((LIElement menuItemElement) {
      MenuItemComponent menuItemComponent = menuItemElement.xtag;
      
      menuItemComponent.onSelected.listen((CustomEvent event) {
        event.preventDefault();
        event.stopPropagation();
        _dispatchSelectedEvent(this, event.detail);
      });
    });
  }
  
  LIElement _getSeparatorElement() {
    LIElement separatorElement = new LIElement();
    separatorElement.classes.addAll(["x-breadcrumb_ui-icon", "x-breadcrumb_ui-icon-triangle-1-e"]);
    return separatorElement;
  }
}