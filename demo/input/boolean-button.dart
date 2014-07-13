import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show BooleanButtonComponent, GrowlComponent;

@CustomTag('boolean-button-demo')
class BooleanButtonDemo extends ShowcaseItem {
  
  @observable String labelOn = 'On';
  @observable String labelOff = 'Off';
  @observable bool showIcon = true;
  @observable bool pressed = false;
  
  BooleanButtonDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/input/boolean-button.html', 'demo/input/boolean-button.dart']);
  }
  
  void onValueChangedFired(Event event, var detail, BooleanButtonComponent target) {
    if (target.pressed) {
      GrowlComponent.postMessage('', 'Boolean button on!');
    }
    else {
      GrowlComponent.postMessage('', 'Boolean button off!');
    }
  }
  
}