import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:animation/animation.dart' as animation;

@CustomTag('h-resizable')
class ResizableComponent extends PolymerElement {
  
  @published bool aspectRatio = false;
  @published bool ghost = false;
  @published int minWidth = 0;
  @published int minHeight = 0;
  @published int maxWidth = 9999;
  @published int maxHeight = 9999;
  
  @observable int currentWidth = 0;
  @observable int currentHeight = 0;
  @observable double ratio = 1.0;
  @observable String resizeMode;
  
  Point _previousPoint;
  
  Element get _content => $['container'].querySelector('*').getDistributedNodes().where((Node node) => node is Element).first;
  Element get _ghost => $['container'].querySelector('#ghost');
  
  ResizableComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    Element ghostElement = _content.clone(true);
    ghostElement.id = 'ghost';
    $['container'].children.insert(1, ghostElement);
    _refreshGhost();
    
    currentWidth = _content.clientWidth;
    currentHeight = _content.clientHeight;
    
    ratio = currentWidth / currentHeight;
    
    _refreshView();
    document.body.onMouseMove.listen(onResizing);
    document.body.onMouseUp.listen(onResizeStopped);
  }
  
  void onResizeStarted(MouseEvent event) {
    _previousPoint = new Point(event.page.x, event.page.y);
    event.preventDefault();
    
    if (event.target == $['handle-east']) {
      resizeMode = 'width';
      document.body.style.cursor = 'e-resize';
    }
    else if (event.target == $['handle-south']) {
      resizeMode = 'height';
      document.body.style.cursor = 's-resize';
    }
    else if (event.target == $['handle-southeast']) {
      resizeMode = 'both';
      document.body.style.cursor = 'se-resize';
    }
  }
  
  void onResizing(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    if (resizeMode == 'width') {
      _refreshWidth(event.page.x);
    }
    else if (resizeMode == 'height') {
      _refreshHeight(event.page.y);
    }
    else if (resizeMode == 'both') {
      _refreshBoth(event.page.x, event.page.y);
    }
    
    _previousPoint = new Point(event.page.x, event.page.y);
  }
  
  void onResizeStopped(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    _previousPoint = null;
    document.body.style.cursor = "auto";
    _refreshView(refreshEverything: true);
  }
  
  void _refreshWidth(int currentX) {
    int dx = currentX - _previousPoint.x;
    
    if (currentWidth + dx > maxWidth || currentWidth + dx < minWidth) {
      return;
    }
    
    if (aspectRatio && (currentWidth / ratio).floor() > maxHeight ||
        aspectRatio && (currentWidth / ratio).floor() < minHeight) {
      return;
    }
    
    currentWidth += dx;
    
    if (aspectRatio) {
      currentHeight = (currentWidth / ratio).floor();
    }
    
    _refreshView();
  }
  
  void _refreshHeight(int currentY) {
    int dy = currentY - _previousPoint.y;
    
    if (currentHeight + dy > maxHeight || currentHeight + dy < minHeight) {
      return;
    }
    
    if (aspectRatio && (currentHeight * ratio).floor() > maxWidth ||
        aspectRatio && (currentHeight * ratio).floor() < minWidth) {
      return;
    }
    
    currentHeight += dy;
    
    if (aspectRatio) {
      currentWidth = (currentHeight * ratio).floor();
    }
    
    _refreshView();
  }
  
  void _refreshBoth(int currentX, int currentY) {
    int dx = currentX - _previousPoint.x;
    int dy = currentY - _previousPoint.y;
    
    if (aspectRatio) {
      if (dx.abs() > dy.abs()) {
        if (currentWidth + dx > maxWidth || currentWidth + dx < minWidth ||
            (currentWidth / ratio).floor() > maxHeight || (currentWidth / ratio).floor() < minHeight) {
          return;
        }
        
        currentWidth += dx;
        currentHeight = (currentWidth / ratio).floor();
      }
      else {
        if (currentHeight + dy > maxHeight || currentHeight + dy < minHeight ||
            (currentHeight * ratio).floor() > maxWidth || (currentHeight * ratio).floor() < minWidth) {
          return;
        }
        
        currentHeight += dy;
        currentWidth = (currentHeight * ratio).floor();
      }
    }
    else {
      if (currentWidth + dx > maxWidth || currentWidth + dx < minWidth ||
          currentHeight + dy > maxHeight || currentHeight + dy < minHeight) {
        return;
      }
      
      currentWidth += dx;
      currentHeight += dy;
    }
    
    _ghost.style
      ..width = '${currentWidth}px'
      ..height = '${currentHeight}px';
    
    _refreshView();
  }
  
  void _refreshGhost() {
    if (_ghost != null) {
      if (!ghost) {
        _ghost.classes.add('hidden');
      }
      else {
        _ghost.classes.remove('hidden');
      }
    }
  }
  
  void _refreshView({bool refreshEverything: false}) {
    _ghost.style
      ..width = '${currentWidth}px'
      ..height = '${currentHeight}px';
    
    if (!refreshEverything) {
      if (!ghost) {
        _content.style
          ..width = '${currentWidth}px'
          ..height = '${currentHeight}px';
      }
    }
    else {
      if (ghost) {
        Map<String, Object> animationProperties = {
          'width': currentWidth,
          'height': currentHeight
        };
        
        animation.animate(_content, properties: animationProperties, duration: 500).onComplete.listen((_) {
          this.dispatchEvent(new Event('resized'));
        });
      }
      else {
        _content.style
          ..width = '${currentWidth}px'
          ..height = '${currentHeight}px';
        
        this.dispatchEvent(new Event('resized'));
      }
    }
  }
  
}