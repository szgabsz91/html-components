library selectitem;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";

part "selectitem/model.dart";

class SelectItemComponent extends WebComponent {
  SelectItemModel model = new SelectItemModel();
  
  DivElement get _button => this.query(".x-selectitem_ui-button");
  
  static const EventStreamProvider<Event> _SELECT_CHANGED_EVENT = const EventStreamProvider<Event>("selectChanged");
  Stream<Event> get onSelectChanged => _SELECT_CHANGED_EVENT.forTarget(this);
  static void _dispatchSelectChangedEvent(Element element) {
    element.dispatchEvent(new Event("selectChanged"));
  }
  
  String get label => model.label;
  set label(String label) => model.label = label;
  
  String get value => model.value;
  set value(String value) => model.value = value;
  
  bool get selected => model.selected;
  set selected(var selected) {
    if (selected is bool) {
      model.selected = selected;
    }
    else if (selected is String) {
      model.selected = selected == "true";
    }
    else {
      throw new ArgumentError("The selected property must be of type bool or String!");
    }
  }
  
  void _onMouseOver() {
    _button.classes.add("x-selectitem_ui-state-hover");
  }
  
  void _onMouseOut() {
    _button.classes.remove("x-selectitem_ui-state-hover");
  }
  
  void _onClicked() {
    model.selected = !model.selected;
    _dispatchSelectChangedEvent(this);
  }
  
  void setLeftCornerRounded() {
    _button.classes.add("x-selectitem_ui-corner-left");
  }
  
  void setRightCornerRounded() {
    _button.classes.add("x-selectitem_ui-corner-right");
  }
}