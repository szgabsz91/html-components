import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

@CustomTag('h-image-compare')
class ImageCompareComponent extends PolymerElement {
  
  @observable int imageWidth = 0;
  @observable int imageHeight = 0;
  @observable int draggablePosition = 0;
  @observable int handlePosition = 26;
  @observable double handleOpacity = 0.0;
  @observable int handleTop = 0;
  @observable int arrowTop = 0;
  
  Point _previousPoint;
  
  ImageCompareComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    new Timer(const Duration(milliseconds: 500), () {
      void init() {
        print($['before-container'].querySelector('content').getDistributedNodes());
        ImageElement beforeImage = $['before-container'].querySelector('content').getDistributedNodes().first;
        ImageElement afterImage = $['after-container'].querySelector('content').getDistributedNodes().first;
        
        imageWidth = beforeImage.clientWidth;
        imageHeight = beforeImage.clientHeight;
        draggablePosition = (imageWidth / 2).floor();
        
        $['handle-container'].onDragStart.listen((MouseEvent event) => event.preventDefault());
        
        if (imageWidth == 0) {
          new Timer(const Duration(milliseconds: 500), init);
        }
      }
      
      init();
    });
  }
  
  void imageHeightChanged() {
    handleTop = ((imageHeight - 56) / 2).floor();
    arrowTop = ((imageHeight - 15) / 2).floor();
  }
  
  void onContainerMouseOver() {
    if (_previousPoint != null) {
      return;
    }
    
    handlePosition = 20;
    handleOpacity = 1.0;
  }
  
  void onContainerMouseOut() {
    if (_previousPoint != null) {
      return;
    }
    
    handlePosition = 26;
    handleOpacity = 0.0;
  }
  
  void onDragStarted(MouseEvent event) {
    _previousPoint = new Point(event.page.x, event.page.y);
    event.preventDefault();
    
    handleOpacity = 0.0;
  }
  
  void onDragging(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    int dx = event.page.x - _previousPoint.x;
    
    draggablePosition += dx;
    
    _previousPoint = new Point(event.page.x, event.page.y);;
  }
  
  void onDragStopped(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    _previousPoint = null;
    handleOpacity = 1.0;
  }
  
}