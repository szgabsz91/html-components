library imagecompare;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "../common/wrappers.dart";

part "imagecompare/model.dart";

class ImageCompareComponent extends WebComponent {
  ImageCompareModel model = new ImageCompareModel();
  
  Point _previousPoint;
  
  DivElement get _handle => this.query(".x-imagecompare_container-handle");
  ImageElement get _beforeImage => this.query(".x-imagecompare_container-before img");
  
  void inserted() {
    model.imageSize.width = _beforeImage.clientWidth;
    model.imageSize.height = _beforeImage.clientHeight;
    model.draggablePosition = (model.imageSize.width / 2).floor();
    _handle.onDragStart.listen((MouseEvent event) => event.preventDefault());
  }
  
  void _onMouseOver() {
    if (_previousPoint != null) {
      return;
    }
    
    model.handlePosition = 20;
    model.handleOpacity = 1.0;
  }
  
  void _onMouseOut() {
    if (_previousPoint != null) {
      return;
    }
    
    model.handlePosition = 26;
    model.handleOpacity = 0.0;
  }
  
  void _onDragStarted(MouseEvent event) {
    _previousPoint = new Point(event.page.x, event.page.y);
    event.preventDefault();
    
    model.handleOpacity = 0.0;
  }
  
  void _onDragging(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    int dx = event.page.x - _previousPoint.x;
    
    model.draggablePosition += dx;
    
    _previousPoint = new Point(event.page.x, event.page.y);;
  }
  
  void _onDragStopped(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    _previousPoint = null;
    model.handleOpacity = 1.0;
  }
}