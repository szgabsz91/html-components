library splitbutton;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "menubar.dart";
import "common/menu.dart";

part "splitbutton/model.dart";

class SplitButtonComponent extends WebComponent {
  SplitButtonModel model = new SplitButtonModel();
  
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
      _menubarElement.classes.toggle("x-splitbutton_ui-helper-hidden");
      
      event.preventDefault();
      event.stopPropagation();
      _dispatchSelectedEvent(this, event.detail);
    });
  }
  
  String get icon => model.icon;
  set icon(String icon) => model.icon = icon;
  
  String get label => model.label;
  set label(String label) => model.label = label;
  
  void _onMouseOver(MouseEvent event) {
    ButtonElement target = event.currentTarget;
    target.classes.add("x-splitbutton_ui-state-hover");
  }
  
  void _onMouseOut(MouseEvent event) {
    ButtonElement target = event.currentTarget;
    target.classes.remove("x-splitbutton_ui-state-hover");
  }
  
  void _onClicked() {
    _menubarElement.classes.toggle("x-splitbutton_ui-helper-hidden");
  }
  
  void _onMainActionClicked(MouseEvent event) {
    _dispatchSelectedEvent(this, model.label);
  }
}