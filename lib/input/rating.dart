import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-rating')
class RatingComponent extends PolymerElement {
  
  @published int stars = 5;
  @published bool cancelable = true;
  @published bool readonly = false;
  @published bool disabled = false;
  @published int value = 0;
  
  @observable List<int> indices = toObservable([1, 2, 3, 4, 5]);
  
  RatingComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
  }
  
  void starsChanged() {
    indices = new Iterable<int>.generate(stars, (int i) => i + 1).toList(growable: false);
  }
  
  void onCancelMouseOver() {
    $['cancel-button'].classes.add('hover');
  }
  
  void onCancelMouseOut() {
    $['cancel-button'].classes.remove('hover');
  }
  
  void onCancelClicked() {
    value = 0;
    
    this.dispatchEvent(new Event('valuechanged'));
  }
  
  void onStarClicked(MouseEvent event, var detail, Element target) {
    if (readonly || disabled) {
      return;
    }
    
    value = target.parent.children.indexOf(target) - 1;
    
    this.dispatchEvent(new Event('valuechanged'));
  }
}