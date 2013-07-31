library rating;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "../common/generators.dart" as generators;

part "rating/model.dart";

class RatingComponent extends WebComponent {
  RatingModel model = new RatingModel();
  
  DivElement get _cancelButton => this.query(".x-rating_ui-rating-cancel");
  
  static const EventStreamProvider<Event> _VALUE_CHANGED_EVENT = const EventStreamProvider<Event>("valueChanged");
  Stream<Event> get onValueChanged => _VALUE_CHANGED_EVENT.forTarget(this);
  static void _dispatchValueChangedEvent(Element element) {
    element.dispatchEvent(new Event("valueChanged"));
  }
  
  int get stars => model.stars;
  set stars(var stars) {
    if (stars is int) {
      model.stars = stars;
    }
    else if (stars is String) {
      model.stars = int.parse(stars);
    }
    else {
      throw new ArgumentError("The stars property must be of type int or String!");
    }
  }
  
  bool get cancelable => model.cancelable;
  set cancelable(var cancelable) {
    if (cancelable is bool) {
      model.cancelable = cancelable;
    }
    else if (cancelable is String) {
      model.cancelable = cancelable == "true";
    }
    else {
      throw new ArgumentError("The cancelable property must be of type bool or String!");
    }
  }
      
  bool get readonly => model.readonly;
  set readonly(var readonly) {
    if (readonly is bool) {
      model.readonly = readonly;
    }
    else if (readonly is String) {
      model.readonly = readonly == "true";
    }
    else {
      throw new ArgumentError("The readonly property must be of type bool or String!");
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
  
  int get value => model.value;
  set value(var value) {
    if (value is int) {
      model.value = value;
    }
    else if (value is String) {
      model.value = int.parse(value);
    }
    else {
      throw new ArgumentError("The value property must be of type int or String!");
    }
  }
  
  void _onMouseOverCancel() {
    _cancelButton.classes.add("x-rating_ui-rating-cancel-hover");
  }
  
  void _onMouseOutCancel() {
    _cancelButton.classes.remove("x-rating_ui-rating-cancel-hover");
  }
  
  void _onCancelClicked() {
    model.value = 0;
    _dispatchValueChangedEvent(this);
  }
  
  void _onStarClicked(int value) {
    if (model.readonly || model.disabled) {
      return;
    }
    
    model.value = value;
    _dispatchValueChangedEvent(this);
  }
}