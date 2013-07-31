library menubutton;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "common/menu.dart";
import "menubar.dart";

part "menubutton/model.dart";

class MenuButtonComponent extends WebComponent {
  MenuButtonModel model = new MenuButtonModel();
  
  DivElement get _menubarElement => this.query('div[is="x-menubar"]');
  MenubarComponent get _menubarComponent => _menubarElement.xtag;
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element, String label) {
    SelectEventDetail detail = new SelectEventDetail(label);
    element.dispatchEvent(new CustomEvent("selected", detail: detail.toString()));
  }
  
  void inserted() {
    _menubarComponent.onSelected.listen((CustomEvent event) {
      _menubarElement.classes.toggle("x-menubutton_ui-helper-hidden");
      
      event.preventDefault();
      event.stopPropagation();
      _dispatchSelectedEvent(this, event.detail);
    });
  }
  
  String get label => model.label;
  set label(String label) => model.label = label;
  
  void _onMouseOver(MouseEvent event) {
    ButtonElement target = event.currentTarget;
    target.classes.add("x-menubutton_ui-state-focus");
  }
  
  void _onMouseOut(MouseEvent event) {
    ButtonElement target = event.currentTarget;
    target.classes.remove("x-menubutton_ui-state-focus");
  }
  
  void _onClicked() {
    _menubarElement.classes.toggle("x-menubutton_ui-helper-hidden");
  }
}