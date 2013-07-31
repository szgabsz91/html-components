library notificationbar;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "package:animation/animation.dart" as animation;

part "notificationbar/model.dart";

class NotificationBarComponent extends WebComponent {
  
  NotificationBarModel model = new NotificationBarModel();
  
  DivElement get _bar => this.query(".x-notificationbar_ui-notificationbar");
  
  void show() {
    if (!model.hidden) {
      return;
    }
    
    Map <String, Object> animationProperties = {
      "padding-top": 50,
      "padding-bottom": 50,
      "height": 25
    };
    
    _bar.style.display = "block";
    
    animation.animate(_bar, properties: animationProperties, duration: 500);
    
    model.hidden = false;
  }
  
  void hide() {
    if (model.hidden) {
      return;
    }
    
    Map<String, Object> animationProperties = {
      "padding-top": 0,
      "padding-bottom": 0,
      "height": 0
    };
    
    _bar.style.display = "block";
    
    animation.animate(_bar, properties: animationProperties, duration: 500);
    
    model.hidden = true;
  }
}