import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show MaskedInputComponent, GrowlComponent;

@CustomTag('masked-input-demo')
class MaskedInputDemo extends ShowcaseItem {
  
  MaskedInputDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/input/masked-input.html', 'demo/input/masked-input.dart']);
  }
  
  void onValueChangedFired(Event event, var detail, MaskedInputComponent target) {
    GrowlComponent.postMessage('Value changed:', target.value);
  }
  
}