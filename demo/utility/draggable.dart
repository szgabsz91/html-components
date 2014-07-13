import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DraggableComponent, GrowlComponent;

@CustomTag('draggable-demo')
class DraggableDemo extends ShowcaseItem {
  
  @observable String axis = 'xy';
  
  DraggableDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/utility/draggable.html', 'demo/utility/draggable.dart']);
  }
  
  void onDraggableDropped(Event event, var detail, DraggableComponent target) {
    GrowlComponent.postMessage('', 'Draggable dropped!');
  }
  
}