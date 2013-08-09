library resizable;

import "package:polymer/polymer.dart";
import "dart:html";
import "dart:async";
import "package:animation/animation.dart" as animation;
import "../common/wrappers.dart";

part "resizable/resize_mode.dart";
part "resizable/model.dart";

@CustomTag("h-resizable")
class ResizableComponent extends PolymerElement with ObservableMixin {
  @observable ResizableModel model = new ResizableModel();
  
  Point _previousPoint;
  
  ShadowRoot get _shadowRoot => getShadowRoot("h-resizable");
  DivElement get _wrapper => _shadowRoot.query(".ui-wrapper");
  Element get _content => _wrapper.query("*");
  Element get _ghostElement => _wrapper.query(".ghost");
  DivElement get _rightHandle => _wrapper.query(".ui-resizable-e");
  DivElement get _bottomHandle => _wrapper.query(".ui-resizable-s");
  DivElement get _bottomRightHandle => _wrapper.query(".ui-resizable-se");
  
  static const EventStreamProvider<Event> _RESIZED_EVENT = const EventStreamProvider<Event>("resized");
  Stream<Event> get onResized => _RESIZED_EVENT.forTarget(this);
  static void _dispatchResizedEvent(Element element) {
    element.dispatchEvent(new Event("resized"));
  }
  
  void inserted() {
    // Walkaround for template
    new Future.delayed(const Duration(milliseconds: 5), () {
      Element content = host.query("*");
      
      Element ghostElement = content.clone(true);
      ghostElement.classes.add("ghost");
      _wrapper.insertAdjacentElement("afterBegin", ghostElement);
      _refreshGhost();
      
      model.currentSize
        ..width = content.clientWidth
        ..height = content.clientHeight;
      model.ratio = model.currentSize.width / model.currentSize.height;
      
      document.body
        ..onMouseMove.listen(_onResizing)
        ..onMouseUp.listen(_onResizeStopped);
      
      _wrapper.insertAdjacentElement("afterBegin", host.query("*"));
      
      _refreshView();
    });
  }
  
  bool get aspectratio => model.aspectRatio;
  void set aspectratio(var aspectratio) {
    if (aspectratio is bool) {
      model.aspectRatio = aspectratio;
    }
    else if (aspectratio is String) {
      model.aspectRatio = aspectratio == "true";
    }
    else {
      throw new ArgumentError("The aspectratio property must be of type bool or String!");
    }
  }
  
  bool get ghost => model.ghost;
  void set ghost(var ghost) {
    if (ghost is bool) {
      model.ghost = ghost;
    }
    else if (ghost is String) {
      model.ghost = ghost == "true";
    }
    else {
      throw new ArgumentError("The ghost property must be of type bool or String!");
    }
    
    _refreshGhost();
  }
  
  int get minwidth => model.minimumSize.width;
  void set minwidth(var minwidth) {
    if (minwidth is int) {
      model.minimumSize.width = minwidth;
    }
    else if (minwidth is String) {
      model.minimumSize.width = int.parse(minwidth);
    }
    else {
      throw new ArgumentError("The minwidth property must be of type int or String!");
    }
  }
  
  int get minheight => model.minimumSize.width;
  void set minheight(var minheight) {
    if (minheight is int) {
      model.minimumSize.height = minheight;
    }
    else if (minheight is String) {
      model.minimumSize.height = int.parse(minheight);
    }
    else {
      throw new ArgumentError("The minheight property must be of type int or String!");
    }
  }
  
  int get maxwidth => model.maximumSize.width;
  void set maxwidth(var maxwidth) {
    if (maxwidth is int) {
      model.maximumSize.width = maxwidth;
    }
    else if (maxwidth is String) {
      model.maximumSize.width = int.parse(maxwidth);
    }
    else {
      throw new ArgumentError("The maxwidth property must be of type int or String!");
    }
  }
  
  int get maxheight => model.maximumSize.height;
  void set maxheight(var maxheight) {
    if (maxheight is int) {
      model.maximumSize.height = maxheight;
    }
    else if (maxheight is String) {
      model.maximumSize.height = int.parse(maxheight);
    }
    else {
      throw new ArgumentError("The maxheight property must be of type int or String!");
    }
  }
  
  void _onResizeStarted(MouseEvent event) {
    _previousPoint = new Point(event.page.x, event.page.y);
    event.preventDefault();
    
    if (event.target == _rightHandle) {
      model.resizeMode = ResizeMode.RESIZE_WIDTH;
      document.body.style.cursor = "e-resize";
    }
    else if (event.target == _bottomHandle) {
      model.resizeMode = ResizeMode.RESIZE_HEIGHT;
      document.body.style.cursor = "s-resize";
    }
    else if (event.target == _bottomRightHandle) {
      model.resizeMode = ResizeMode.RESIZE_BOTH;
      document.body.style.cursor = "se-resize";
    }
  }
  
  void _onResizing(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    if (model.resizeMode == ResizeMode.RESIZE_WIDTH) {
      _refreshWidth(event.page.x);
    }
    else if (model.resizeMode == ResizeMode.RESIZE_HEIGHT) {
      _refreshHeight(event.page.y);
    }
    else if (model.resizeMode == ResizeMode.RESIZE_BOTH) {
      _refreshBoth(event.page.x, event.page.y);
    }
    
    _previousPoint = new Point(event.page.x, event.page.y);
  }
  
  void _onResizeStopped(MouseEvent event) {
    if (_previousPoint == null) {
      return;
    }
    
    _previousPoint = null;
    document.body.style.cursor = "auto";
    _refreshView(refreshEverything: true);
  }
  
  void _refreshWidth(int currentX) {
    int dx = currentX - _previousPoint.x;
    
    if (model.currentSize.width + dx > model.maximumSize.width ||
        model.currentSize.width + dx < model.minimumSize.width) {
      return;
    }
    
    if (model.aspectRatio && (model.currentSize.width / model.ratio).floor() > model.maximumSize.height ||
        model.aspectRatio && (model.currentSize.width / model.ratio).floor() < model.minimumSize.height) {
      return;
    }
    
    model.currentSize.width += dx;
    
    if (model.aspectRatio) {
      model.currentSize.height = (model.currentSize.width / model.ratio).floor();
    }
    
    _refreshView();
  }
  
  void _refreshHeight(int currentY) {
    int dy = currentY - _previousPoint.y;
    
    if (model.currentSize.height + dy > model.maximumSize.height ||
        model.currentSize.height + dy < model.minimumSize.height) {
      return;
    }
    
    if (model.aspectRatio && (model.currentSize.height * model.ratio).floor() > model.maximumSize.width ||
        model.aspectRatio && (model.currentSize.height * model.ratio).floor() < model.minimumSize.width) {
      return;
    }
    
    model.currentSize.height += dy;
    
    if (model.aspectRatio) {
      model.currentSize.width = (model.currentSize.height * model.ratio).floor();
    }
    
    _refreshView();
  }
  
  void _refreshBoth(int currentX, int currentY) {
    int dx = currentX - _previousPoint.x;
    int dy = currentY - _previousPoint.y;
    
    if (model.aspectRatio) {
      if (dx.abs() > dy.abs()) {
        if (model.currentSize.width + dx > model.maximumSize.width || model.currentSize.width + dx < model.minimumSize.width ||
            (model.currentSize.width / model.ratio).floor() > model.maximumSize.height || (model.currentSize.width / model.ratio).floor() < model.minimumSize.height) {
          return;
        }
        
        model.currentSize.width += dx;
        model.currentSize.height = (model.currentSize.width / model.ratio).floor();
      }
      else {
        if (model.currentSize.height + dy > model.maximumSize.height || model.currentSize.height + dy < model.minimumSize.height ||
            (model.currentSize.height * model.ratio).floor() > model.maximumSize.width || (model.currentSize.height * model.ratio).floor() < model.minimumSize.width) {
          return;
        }
        
        model.currentSize.height += dy;
        model.currentSize.width = (model.currentSize.height * model.ratio).floor();
      }
    }
    else {
      if (model.currentSize.width + dx > model.maximumSize.width || model.currentSize.width + dx < model.minimumSize.width ||
          model.currentSize.height + dy > model.maximumSize.height || model.currentSize.height + dy < model.minimumSize.height) {
        return;
      }
      
      model.currentSize.width += dx;
      model.currentSize.height += dy;
    }
    
    _ghostElement.style
      ..width = "${model.currentSize.width}px"
      ..height = "${model.currentSize.height}px";
    
    _refreshView();
  }
  
  void _refreshGhost() {
    if (_ghostElement != null) {
      if (!model.ghost) {
        _ghostElement.classes.add("ui-helper-hidden");
      }
      else {
        _ghostElement.classes.remove("ui-helper-hidden");
      }
    }
  }
  
  void _refreshView({bool refreshEverything: false}) {
    _ghostElement.style
      ..width = "${model.currentSize.width}px"
      ..height = "${model.currentSize.height}px";
    
    if (!refreshEverything) {
      if (!model.ghost) {
        _content.style
          ..width = "${model.currentSize.width}px"
          ..height = "${model.currentSize.height}px";
      }
    }
    else {
      if (model.ghost) {
        Map<String, Object> animationProperties = {
          "width": model.currentSize.width,
          "height": model.currentSize.height
        };
        
        animation.animate(_content, properties: animationProperties, duration: 500).onComplete.listen((_) {
          _dispatchResizedEvent(this);
        });
      }
      else {
        _content.style
          ..width = "${model.currentSize.width}px"
          ..height = "${model.currentSize.height}px";
        
        _dispatchResizedEvent(this);
      }
    }
  }
}