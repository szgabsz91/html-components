library tab;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";

part "tab/model.dart";
part "tab/listener.dart";

class TabComponent extends WebComponent {
  TabModel model = new TabModel();
  
  DivElement get _contentContainer => this.query(".content");
  
  void inserted() {
    String content = _contentContainer.innerHtml;
    model.content = content;
    _contentContainer.remove();
  }
  
  String get label => model.label;
  set label(String label) => model.label = label;
  
  bool get selected => model.selected;
  set selected(var selected) {
    if (selected is bool) {
      model.selected = selected;
    }
    else if (selected is String) {
      model.selected = selected == "true";
    }
    else {
      throw new ArgumentError("The selection property must be of type bool or String!");
    }
  }
  
  bool get disabled => model.disabled;
  set disabled(var disabled) {
    if (disabled is bool) {
      model.disabled = disabled;
    }
    else if (disabled is String) {
      model.disabled = disabled == "true";
    }
    else {
      throw new ArgumentError("The disabled property must be of type bool or String!");
    }
  }
  
  bool get closabled => model.closable;
  set closable(var closable) {
    if (closable is bool) {
      model.closable = closable;
    }
    else if (closable is String) {
      model.closable = closable == "true";
    }
    else {
      throw new ArgumentError("The closable property must be of type bool or String!");
    }
  }
}