library growl_message;

import "package:polymer/polymer.dart";
import "dart:html";
import "dart:async";
import "package:animation/animation.dart" as animation;
import "../common/enums.dart";

part "growl_message/model.dart";

@CustomTag("h-growl-message")
class GrowlMessageComponent extends PolymerElement with ObservableMixin {
  @observable GrowlMessageModel model = new GrowlMessageModel();
  
  DivElement get _container => getShadowRoot("h-growl-message").query(".ui-growl-item-container");
  SpanElement get _icon => getShadowRoot("h-growl-message").query("#icon");
  
  static const EventStreamProvider<Event> _CLOSED_EVENT = const EventStreamProvider<Event>("closed");
  Stream<Event> get onClosed => _CLOSED_EVENT.forTarget(this);
  static void _dispatchClosedEvent(Element element) {
    element.dispatchEvent(new Event("closed"));
  }
  
  String get summary => model.summary;
  set summary(String summary) => model.summary = summary;
  
  String get detail => model.detail;
  set detail(String detail) => model.detail = detail;
  
  Severity get severity => model.severity;
  set severity(var severity) {
    if (severity is Severity) {
      model.severity = severity;
    }
    else if (severity is String) {
      model.severity = new Severity.fromString(severity);
    }
    else {
      throw new ArgumentError("The severity property must be of type GrowMessageSeverity or String!");
    }
  }
  
  void close() {
    _container.style
      ..opacity = "0"
      ..margin = "0"
      ..padding = "0";
    
    Map<String, Object> animationProperties = {
      "height": 0
    };

    animation.animate(_container, properties: animationProperties, duration: 500).onComplete.listen((_) {
      _dispatchClosedEvent(this);
    });
  }
}