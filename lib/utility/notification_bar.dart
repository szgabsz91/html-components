import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-notification-bar')
class NotificationBarComponent extends PolymerElement {
  
  @published int z = 2000;
  
  bool _visible = false;
  int _contentHeight = 0;
  
  NotificationBarComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    DivElement container = $['container'];
    _contentHeight = container.clientHeight;
    container.style.height = '0px';
  }
  
  bool get visible => _visible;
  int get contentHeight => _contentHeight;
  
  void show() {
    if (_visible) {
      return;
    }
    
    $['container'].style.height = '${_contentHeight}px';
    
    _visible = true;
  }
  
  void hide() {
    if (!_visible) {
      return;
    }
    
    $['container'].style.height = '0';
    
    _visible = false;
  }
  
}