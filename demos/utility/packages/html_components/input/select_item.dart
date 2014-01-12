import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'select_item/model.dart';

export 'select_item/model.dart';

@CustomTag('h-select-item')
class SelectItemComponent extends PolymerElement {
  
  @published String label = '';
  @published String value = '';
  //@published bool selected = false;
  
  // Class binding does not work properly yet
  // When it does, this can be replaced by a publsihed bool attribute
  // And the class binding can be uncommented in the HTML
  bool _selected = false;
  @published bool get selected => _selected;
  void set selected(bool selected) {
    _selected = selected;
    
    scheduleMicrotask(() {
      if (selected) {
        $['container'].classes
          ..remove('hover')
          ..add('selected');
      }
      else {
        $['container'].classes.remove('selected');
      }
    });
  }
  
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