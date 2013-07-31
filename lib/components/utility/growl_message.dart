library growl_message;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "package:animation/animation.dart" as animation;

part "growl_message/listener.dart";
part "growl_message/severity.dart";
part "growl_message/model.dart";

class GrowlMessageComponent extends WebComponent {
  GrowlMessageModel model = new GrowlMessageModel();
  
  DivElement get _container => this.query(".x-growl-message_ui-growl-item-container");
  
  static const EventStreamProvider<Event> _CLOSED_EVENT = const EventStreamProvider<Event>("closed");
  Stream<Event> get onClosed => _CLOSED_EVENT.forTarget(this);
  static void _dispatchClosedEvent(Element element) {
    element.dispatchEvent(new Event("closed"));
  }
  
  String get summary => model.summary;
  set summary(String summary) => model.summary = summary;
  
  String get detail => model.detail;
  set detail(String detail) => model.detail = detail;
  
  GrowlMessageSeverity get severity => model.severity;
  set severity(var severity) {
    if (severity is GrowlMessageSeverity) {
      model.severity = severity;
    }
    else if (severity is String) {
      model.severity = new GrowlMessageSeverity.fromString(severity);
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
      _container.parent.remove();
      _dispatchClosedEvent(this);
      model.onClose();
    });
  }
}