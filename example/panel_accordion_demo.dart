import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('accordion-demo')
class AccordionDemo extends PolymerElement {
  
  @observable List<TabModel> tabs = toObservable([
    new TabModel('Tab 1', false, false, true, false, 'Tab 1 content'),
    new TabModel('Tab 2', true, false, true, false, 'Tab 2 content'),
    new TabModel('Tab 3', false, false, true, false, 'Tab 3 content'),
    new TabModel('Tab 4', false, true, true, false, 'Tab 4 content')
  ]);
  
  AccordionDemo.created() : super.created();
  
  void onAccordionSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected tab:', detail.header);
  }
  
  void onAccordionDeselected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Deselected tab:', detail.header);
  }
  
}