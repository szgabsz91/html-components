library draggable;

import "package:polymer/polymer.dart";
import "dart:html";
import "dart:async";

part "draggable/draggable_axis.dart";
part "draggable/model.dart";

@CustomTag("h-draggable")
class DraggableComponent extends PolymerElement with ObservableMixin {
  @observable DraggableModel model = new DraggableModel();
  
  Point _previousPoint;
  
  ShadowRoot get _shadowRoot => getShadowRoot("h-draggable");
  DivElement get _draggable => _shadowRoot.query(".draggable");
  
  static const EventStreamProvider<Event> _DROPPED_EVENT = const EventStreamProvider<Event>("dropped");
  Stream<Event> get onDropped => _DROPPED_EVENT.forTarget(this);
  static void _dispatchDroppedEvent(Element element) {
    element.dispatchEvent(new Event("dropped"));
  }
  
  void inserted() {
    this.onMouseDown.listen((MouseEvent event) => _onDragStarted(event));
    
    document.body.onMouseMove.listen(_onDragging);
    document.body.onMouseUp.listen(_onDragStopped);
    _draggable.onDragStart.listen((MouseEvent event) => event.preventDefault());
    
    _draggable.insertAdjacentElement("afterBegin", host.query("*"));
  }
  
  DraggableAxis get axis => model.axis;
  void set axis(var axis) {
    if (axis is DraggableAxis) {
      model.axis = axis;
    }
    else if (axis is String) {
      if (["x", "y", "xy"].contains(axis)) {
        model.axis = new DraggableAxis.fromString(axis);
      }
      else {
        throw new ArgumentError("The axis property must be x, y or xy!");
      }
    }
    else {
      throw new ArgumentError("The axis property must be of type DraggableAxis or String!");
    }
  }
  
  void _onDragStarted(MouseEvent event) {
    _previousPoint = new Point(event.page.x, event.page.y);
  }
  
  void _onDragging(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    int dx = event.page.x - _previousPoint.x;
    int dy = event.page.y - _previousPoint.y;
    
    if (model.axis == DraggableAxis.X) {
      dy = 0;
    }
    else if (model.axis == DraggableAxis.Y) {
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