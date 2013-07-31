library booleanbutton;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";

part "booleanbutton/model.dart";

class BooleanButtonComponent extends WebComponent {
  BooleanButtonModel model = new BooleanButtonModel();
  
  DivElement get _buttonRoot => this.query("div");
  
  static const EventStreamProvider<Event> _VALUE_CHANGED_EVENT = const EventStreamProvider<Event>("valueChanged");
  Stream<Event> get onValueChanged => _VALUE_CHANGED_EVENT.forTarget(this);
  static void _dispatchValueChangedEvent(Element element) {
    element.dispatchEvent(new Event("valueChanged"));
  }
  
  String get labelon => model.labelOn;
  set labelon(String labelon) => model.labelOn = labelon;
  
  String get labeloff => model.labelOff;
  set labeloff(String labeloff) => model.labelOff = labeloff;
  
  bool get showicon => model.showIcon;
  set showicon(var showicon) {
    if (showicon is bool) {
      model.showIcon = showicon;
    }
    else if (showicon is String) {
      model.showIcon = showicon == "true";
    }
    else {
      throw new ArgumentError("The showicon property must be of type bool or String!");
    }
  }
  
  bool get pressed => model.pressed;
  set pressed(var pressed) {
    if (pressed is bool) {
      model.pressed = pressed;
    }
    else if (pressed is String) {
      model.pressed = pressed == "true";
    }
    else {
      throw new ArgumentError("The pressed property must be of type bool or String!");
    }
    
    _dispatchValueChangedEvent(this);
  }
  
  void _onMouseOver() {
    if (model.pressed) {
      return;
    }
    
    _buttonRoot.classes.add("x-booleanbutton_ui-state-hover");
  }
  
  void _onMouseOut() {
    _buttonRoot.classes.remove("x-booleanbutton_ui-state-hover");
  }
  
  void _onClicked() {
    model.pressed = !model.pressed;
    _onMouseOut();
    _dispatchValueChangedEvent(this);
  }
}