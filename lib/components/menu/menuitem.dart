library menuitem;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "common/menu.dart";

part "menuitem/model.dart";

class MenuItemComponent extends WebComponent {
  MenuItemModel model = new MenuItemModel();
  
  AnchorElement get _linkElement => this.query(".x-menuitem_ui-menuitem-link");
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element) {
    // FIXME If the content element is in its own line, the event target will contain whitespace
    MenuItemComponent menuItemComponent = element.xtag;
    SpanElement spanElement = menuItemComponent.query(".x-menuitem_ui-menuitem-text");
    String label = spanElement.text;
    SelectEventDetail detail = new SelectEventDetail(label);
    element.dispatchEvent(new CustomEvent("selected", detail: detail.toString()));
  }
  
  String get url => model.url;
  set url(String url) => model.url = url;
  
  String get icon => model.icon;
  set icon(String icon) => model.icon = icon;
  
  String get target => model.target;
  set target(String target) => model.target = target;
  
  void _onClicked(MouseEvent event) {
    if (!model._isExternal) {
      event.preventDefault();
    }
    
    _dispatchSelectedEvent(this);
  }
  
  void _onMouseOver() {
    _linkElement.classes.add("x-menuitem_ui-state-hover");
  }
  
  void _onMouseOut() {
    _linkElement.classes.remove("x-menuitem_ui-state-hover");
  }
}