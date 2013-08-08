library notificationbar;

import "package:polymer/polymer.dart";
import "dart:html";
import "package:animation/animation.dart" as animation;

part "notificationbar/model.dart";

@CustomTag("h-notificationbar")
class NotificationbarComponent extends PolymerElement with ObservableMixin {
  @observable NotificationbarModel model = new NotificationbarModel();
  
  ShadowRoot get _shadowRoot => getShadowRoot("h-notificationbar");
  DivElement get _bar => _shadowRoot.query(".ui-notificationbar");
  
  void inserted() {
    bindCssClass(_bar, "ui-helper-hidden", this, "model.hidden");
  }
  
  void show() {
    if (!model.hidden) {
      return;
    }
    
    Map <String, Object> animationProperties = {
      "padding-top": 50,
      "padding-bottom": 50,
      "height": 25
    };
    
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
    
    animation.animate(_bar, properties: animationProperties, duration: 500).onComplete.listen((_) {
      model.hidden = true;
    });
  }
}