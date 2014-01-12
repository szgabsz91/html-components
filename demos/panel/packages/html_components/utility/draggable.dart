import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-draggable')
class DraggableComponent extends PolymerElement {
  
  @published int top = 0;
  @published int left = 0;
  @published String axis = 'xy';
  
  Point _previousPoint;
  
  DraggableComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    document.body.onMouseMove.listen(onDragging);
    document.body.onMouseUp.listen(onDragStopped);
    $['container'].onDragStart.listen((MouseEvent event) => event.preventDefault());
    
    $['container'].querySelector('content').getDistributedNodes().where((Node node) => node is Element).first.style.cursor = 'move';
  }
  
  void onDragStarted(MouseEvent event) {
    _previousPoint = new Point(event.page.x, event.page.y);
  }
  
  void onDragging(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    int dx = event.page.x - _previousPoint.x;
    int dy = event.page.y - _previousPoint.y;
    
    if (axis == 'x') {
      dy = 0;
    }
    else if (axis == 'y') {
      dx = 0;
    }
    
    top += dy;
    left += dx;
    
    _previousPoint = new Point(event.page.x, event.page.y);
  }
  
  void onDragStopped(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    _previousPoint = null;
    
    this.dispatchEvent(new Event('dropped'));
  }
}