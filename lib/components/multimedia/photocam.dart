library photocam;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "package:js/js.dart" as js;

part "photocam/model.dart";

class PhotocamComponent extends WebComponent {
  PhotocamModel model = new PhotocamModel();
  js.Proxy _photocamProxy;
  
  ButtonElement get _startButton => this.queryAll("button").elementAt(0);
  ButtonElement get _stopButton => this.queryAll("button").elementAt(1);
  ButtonElement get _snapshotButton => this.queryAll("button").elementAt(2);
  
  void inserted() {
    js.scoped(() {
      js.Proxy context = js.context;
      _photocamProxy = new js.Proxy(context["PhotocamProxy"], "#photocam-video", "#photocam-canvas", "#photocam-image");
      js.retain(_photocamProxy);
    });
  }
  
  int get width => model.width;
  set width(var width) {
    if (width is int) {
      model.width = width;
    }
    else if (width is String) {
      model.width = int.parse(width);
    }
    else {
      throw new ArgumentError("The width property must be of type int or String!");
    }
  }
  
  int get height => model.height;
  set height(var height) {
    if (height is int) {
      model.height = height;
    }
    else if (height is String) {
      model.height = int.parse(height);
    }
    else {
      throw new ArgumentError("The height property must be of type int or String!");
    }
  }
  
  bool get audio => model.audio;
  set audio(var audio) {
    if (audio is bool) {
      model.audio = audio;
    }
    else if (audio is String) {
      model.audio = audio == "true";
    }
    else {
      throw new ArgumentError("The audio property must be of type bool or String!");
    }
    
    if (model.started) {
     restart();
    }
  }
  
  String get effect => model.effect;
  set effect(String effect) => model.effect = effect;
  
  void start() {
    _photocamProxy["start"](model.audio);
    model.started = true;
  }
  
  void stop() {
    _photocamProxy["stop"]();
    model.started = false;
  }
  
  void snapshot() {
    _photocamProxy["snapshot"]();
  }
  
  void restart() {
    stop();
    start();
  }
  
  void _onStartClicked(MouseEvent event) {
    event.preventDefault();
    
    if (model.started) {
      return;
    }
    
    ButtonElement button = event.currentTarget;
    
    start();
  }
  
  void _onStopClicked(MouseEvent event) {
    event.preventDefault();
    
    if (!model.started) {
      return;
    }
    
    ButtonElement button = event.currentTarget;
    
    stop();
    
    button.classes.remove("x-photocam_ui-state-hover");
  }
  
  void _onSnapshotClicked(MouseEvent event) {
    event.preventDefault();
    
    if (!model.started) {
      return;
    }
    
    ButtonElement button = event.currentTarget;
    
    snapshot();
  }
  
  void _onMouseOver(MouseEvent event) {
    ButtonElement button = event.currentTarget;
    if (button.classes.contains("x-photocam_ui-state-disabled")) {
      return;
    }
    
    button.classes.add("x-photocam_ui-state-hover");
  }
  
  void _onMouseOut(MouseEvent event) {
    ButtonElement button = event.currentTarget;
    
    button.classes.remove("x-photocam_ui-state-hover");
  }
}