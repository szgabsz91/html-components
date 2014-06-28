import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('panel-demo')
class PanelDemo extends PolymerElement {
  
  @observable bool closable = true;
  @observable bool toggleable = true;
  
  PanelDemo.created() : super.created();
  
  void onPanelToggled(CustomEvent event, var detail, Element target) {
    switch (detail) {
      case 'HIDDEN':
        GrowlComponent.postMessage('', 'Panel is hidden!');
        break;
        
      case 'VISIBLE':
        GrowlComponent.postMessage('', 'Panel is visible!');
        break;
    }
  }
  
  void onPanelClosed() {
    GrowlComponent.postMessage('', 'Panel is closed!');
  }
  
}