import 'package:polymer/polymer.dart';
import 'package:html_components/html_components.dart';

@CustomTag('draggable-demo')
class DraggableDemo extends PolymerElement {
  
  @observable String axis = 'xy';
  
  bool get applyAuthorStyles => true;
  
  DraggableDemo.created() : super.created();
  
  void onDraggableDropped() {
    GrowlComponent.postMessage('', 'Draggable dropped!');
  }
  
}