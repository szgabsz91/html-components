library menubar;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "common/menu.dart";
import "menuitem.dart";

part "menubar/model.dart";

class MenubarComponent extends WebComponent {
  MenubarModel model = new MenubarModel();
  
  List<LIElement> get _menuItemElements => this.queryAll('li[is="x-menuitem"]');
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element, String label) {
    SelectEventDetail detail = new SelectEventDetail(label);
    element.dispatchEvent(new CustomEvent("selected", detail: detail.toString()));
  }
  
  void inserted() {
    _menuItemElements.forEach((LIElement menuItemElement) {
      MenuItemComponent menuItemComponent = menuItemElement.xtag;
      
      menuItemComponent.onSelected.listen((CustomEvent event) {
        event.preventDefault();
        event.stopPropagation();
        _dispatchSelectedEvent(this, event.detail);
      });
    });
  }
  
  String get orientation => model.orientation;
  set orientation(String orientation) => model.orientation = orientation;
}