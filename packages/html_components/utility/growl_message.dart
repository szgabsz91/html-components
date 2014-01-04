import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart' as animation;
import 'growl_message/model.dart';

export 'growl_message/model.dart';

@CustomTag('h-growl-message')
class GrowlMessageComponent extends PolymerElement {
  
  // FIXME If I omit the getters and setters and notifyPropertyChange, then
  // the components are empty in Chrome
  @published String summary;
  @published String detail;
  @published String severity;
  
  static const EventStreamProvider<Event> _CLOSED_EVENT = const EventStreamProvider<Event>('closed');
  Stream<Event> get onClosed => _CLOSED_EVENT.forTarget(this);
  static void _dispatchClosedEvent(Element element) {
    element.dispatchEvent(new Event('closed'));
  }
  
  GrowlMessageComponent.created() : super.created();
  
  GrowlMessageModel get model => new GrowlMessageModel(summary, detail, severity);
  
  void onClosing() {
    DivElement container = $['container'];
    
    container.style
      ..opacity = '0'
      ..margin = '0'
      ..padding = '0';
    
    var animationProperties = {
      'height': 0
    };
    
    animation.animate(container, properties: animationProperties, duration: 500).onComplete.listen((_) {
      _dispatchClosedEvent(this);
    });
  }
  
}