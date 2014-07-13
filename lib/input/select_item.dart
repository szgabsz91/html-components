import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'select_item/model.dart';

export 'select_item/model.dart';

@CustomTag('h-select-item')
class SelectItemComponent extends PolymerElement {
  
  @published String label = '';
  @published String value = '';
  @published bool selected = false;
  
  SelectItemComponent.created() : super.created();
  
  SelectItemModel get model => new SelectItemModel(label, value, selected);
  
  void onItemMouseOver() {
    if (selected) {
      return;
    }
    
    $['container'].classes.add('hover');
  }
  
  void onItemMouseOut() {
    $['container'].classes.remove('hover');
  }
  
  void onItemClicked() {
    selected = !selected;
    
    this.dispatchEvent(new Event('valueChanged'));
  }
  
  void setLeftCornerRounded() {
    $['container'].classes.add('corner-left');
  }
  
  void setRightCornerRounded() {
    $['container'].classes.add('corner-right');
  }
  
}