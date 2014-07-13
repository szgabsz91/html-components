import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show StringToInt, RatingComponent, GrowlComponent;

@CustomTag('rating-demo')
class RatingDemo extends ShowcaseItem {
  
  @observable int stars = 5;
  @observable int value = 3;
  @observable bool cancelable = true;
  @observable bool readonly = false;
  @observable bool disabled = false;
  
  final StringToInt asInteger = new StringToInt();
  
  RatingDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/input/rating.html', 'demo/input/rating.dart']);
  }
  
  void onValueChangedFired(Event event, var detail, RatingComponent target) {
    GrowlComponent.postMessage('Value changed:', '${target.value}');
  }
  
}