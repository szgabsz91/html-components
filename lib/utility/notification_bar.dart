import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:animation/animation.dart' as animation;

@CustomTag('h-notification-bar')
class NotificationBarComponent extends PolymerElement {
  
  bool _visible = false;
  int _contentHeight = 0;
  
  DivElement get _contentContainer => this.shadowRoot.querySelector('#container');
  
  NotificationBarComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    _contentHeight = _contentContainer.clientHeight;
    _contentContainer.style.height = '0px';
  }
  
  bool get visible => _visible;
  int get contentHeight => _contentHeight;
  
  void show() {
    if (_visible) {
      return;
    }
    
    Map<String, Object> animationProperties = {
      "height": _contentHeight
    };
    
    animation.animate(_contentContainer, properties: animationProperties, duration: 500);
    
    _visible = true;
  }
  
  void hide() {
    if (!_visible) {
      return;
    }
    
    Map<String, Object> animationProperties = {
      "height": 0
    };
    
    animation.animate(_contentContainer, properties: animationProperties, duration: 500);
    
    _visible = false;
  }
  
}