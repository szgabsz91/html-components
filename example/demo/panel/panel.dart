import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show PanelComponent, GrowlComponent;

@CustomTag('panel-demo')
class PanelDemo extends ShowcaseItem {
  
  @observable bool closable = true;
  @observable bool toggleable = true;
  
  PanelDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/panel/panel.html', 'demo/panel/panel.dart']);
  }
  
  void onPanelToggled(CustomEvent event, var detail, PanelComponent target) {
    switch (detail) {
      case 'HIDDEN':
        GrowlComponent.postMessage('', 'Panel is hidden!');
        break;
        
      case 'VISIBLE':
        GrowlComponent.postMessage('', 'Panel is visible!');
        break;
    }
  }
  
  void onPanelClosed(Event event, var detail, PanelComponent target) {
    GrowlComponent.postMessage('', 'Panel is closed!');
  }
  
}