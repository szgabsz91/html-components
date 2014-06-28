import 'package:polymer/polymer.dart';
import 'package:polymer_expressions/filter.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

class StringToInt extends Transformer<String, int> {
  String forward(int value) => '$value';
  int reverse(String string) => string == null ? null : int.parse(string);
}

@CustomTag('rating-demo')
class RatingDemo extends PolymerElement {
  
  @observable int stars = 5;
  @observable int value = 3;
  @observable bool cancelable = true;
  @observable bool readonly = false;
  @observable bool disabled = false;
  
  final Transformer asInteger = new StringToInt();
  
  RatingDemo.created() : super.created();
  
  void onValueChangedFired(Event event, var detail, RatingComponent target) {
    GrowlComponent.postMessage('Value changed:', '${target.value}');
  }
  
}