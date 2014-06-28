import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('masked-input-demo')
class MaskedInputDemo extends PolymerElement {
  
  MaskedInputDemo.created() : super.created();
  
  void onValueChangedFired(Event event, var detail, InputElement target) {
    GrowlComponent.postMessage('Value changed:', target.value);
  }
  
}