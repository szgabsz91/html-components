import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('boolean-button-demo')
class BooleanButtonDemo extends PolymerElement {
  
  @observable String labelOn = 'On';
  @observable String labelOff = 'Off';
  @observable bool showIcon = true;
  @observable bool pressed = false;
  
  bool get applyAuthorStyles => true;
  
  BooleanButtonDemo.created() : super.created();
  
  void onValueChangedFired(Event event, var detail, Element target) {
    if (target.pressed) {
      GrowlComponent.postMessage('', 'Boolean button on!');
    }
    else {
      GrowlComponent.postMessage('', 'Boolean button off!');
    }
  }
  
}