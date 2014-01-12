import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-split-button')
class SplitButtonComponent extends PolymerElement {
  
  @published String label = "";
  @published String icon;
  
  SplitButtonComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    $['menubar'].on['selected'].listen((CustomEvent event) {
      $['menubar'].classes.toggle('hidden');
    });
  }
  
  void onButtonMouseOver(MouseEvent event, var detail, Element target) {
    target.classes.add('hover');
  }
  
  void onButtonMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onButtonClicked() {
    $['menubar'].classes.toggle('hidden');
  }
  
  void onMainActionClicked(MouseEvent event) {
    this.dispatchEvent(new CustomEvent('selected', detail: label));
  }
  
}