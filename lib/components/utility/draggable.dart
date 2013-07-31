library draggable;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";

part "draggable/model.dart";

class DraggableComponent extends WebComponent {
  
  DraggableModel model = new DraggableModel();
  
  Point _previousPoint;
  
  DivElement get _draggable => this.query(".x-draggable_draggable");
  
  static const EventStreamProvider<Event> _DROPPED_EVENT = const EventStreamProvider<Event>("dropped");
  Stream<Event> get onDropped => _DROPPED_EVENT.forTarget(this);
  static void _dispatchDroppedEvent(Element element) {
    element.dispatchEvent(new Event("dropped"));
  }
  
  void inserted() {
    document.body.onMouseMove.listen(_onDragging);
    document.body.onMouseUp.listen(_onDragStopped);
    _draggable.onDragStart.listen((MouseEvent event) => event.preventDefault());
  }
  
  String get axis => model.axis;
  set axis(String axis) => model.axis = axis;
  
  void _onDragStarted(MouseEvent event) {
    _previousPoint = new Point(event.page.x, event.page.y);
  }
  
  void _onDragging(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    int dx = event.page.x - _previousPoint.x;
    int dy = event.page.y - _previousPoint.y;
    
    if (model.axis == "x") {
      dy = 0;
    }
    else if (model.axis == "y") {
      dx = 0;
    }
    
    model.top += dy;
    model.left += dx;
    
    _previousPoint = new Point(event.page.x, event.page.y);
  }
  
  void _onDragStopped(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    _previousPoint = null;
    
    _dispatchDroppedEvent(this);
  }
}