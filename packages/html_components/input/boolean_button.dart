import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-boolean-button')
class BooleanButtonComponent extends PolymerElement {
  
  @published String labelOn = "On";
  @published String labelOff = "Off";
  @published bool showIcon = false;
  @published bool pressed = false;
  
  BooleanButtonComponent.created() : super.created();
  
  void onButtonMouseOver() {
    if (pressed) {
      return;
    }
    
    $['container'].classes.add('hover');
  }
  
  void onButtonMouseOut() {
    $['container'].classes.remove('hover');
  }
  
  void onButtonClicked() {
    pressed = !pressed;
    
    this.dispatchEvent(new Event('valueChanged'));
  }
  
}