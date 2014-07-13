import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show AccordionComponent, GrowlComponent;

@CustomTag('accordion-static-demo')
class AccordionStaticDemo extends ShowcaseItem {
  
  @observable String selection = 'single';
  
  AccordionStaticDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/panel/accordion/static.html', 'demo/panel/accordion/static.dart']);
  }
  
  void onAccordionSelected(CustomEvent event, var detail, AccordionComponent target) {
    GrowlComponent.postMessage('Selected tab:', detail.header);
  }
  
  void onAccordionDeselected(CustomEvent event, var detail, AccordionComponent target) {
    GrowlComponent.postMessage('Deselected tab:', detail.header);
  }
  
}