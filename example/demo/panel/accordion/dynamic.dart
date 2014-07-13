import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show TabModel, AccordionComponent, GrowlComponent;

@CustomTag('accordion-dynamic-demo')
class AccordionDynamicDemo extends ShowcaseItem {
  
  @observable List<TabModel> tabs = toObservable([
    new TabModel('Tab 1', false, false, true, false, 'Tab 1 content'),
    new TabModel('Tab 2', true, false, true, false, 'Tab 2 content'),
    new TabModel('Tab 3', false, false, true, false, 'Tab 3 content'),
    new TabModel('Tab 4', false, true, true, false, 'Tab 4 content')
  ]);
  
  AccordionDynamicDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/panel/accordion/dynamic.html', 'demo/panel/accordion/dynamic.dart']);
  }
  
  void onAccordionSelected(CustomEvent event, var detail, AccordionComponent target) {
    GrowlComponent.postMessage('Selected tab:', detail.header);
  }
  
  void onAccordionDeselected(CustomEvent event, var detail, AccordionComponent target) {
    GrowlComponent.postMessage('Deselected tab:', detail.header);
  }
  
}