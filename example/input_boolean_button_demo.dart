import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('boolean-button-demo')
class BooleanButtonDemo extends PolymerElement {
  
  @observable String labelOn = 'On';
  @observable String labelOff = 'Off';
  @observable bool showIcon = true;
  @observable bool pressed = false;
  
  BooleanButtonDemo.created() : super.created();
  
  void onValueChangedFired(Event event, var detail, BooleanButtonComponent target) {
    if (target.pressed) {
      GrowlComponent.postMessage('', 'Boolean button on!');
    }
    else {
      GrowlComponent.postMessage('', 'Boolean button off!');
    }
  }
  
}