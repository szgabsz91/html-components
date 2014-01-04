import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('accordion-page')
class AccordionPage extends PolymerElement {
  
  @observable List<TabModel> tabs = toObservable([
    new TabModel('Tab 1', false, false, true, false, 'Tab 1 content'),
    new TabModel('Tab 2', true, false, true, false, 'Tab 2 content'),
    new TabModel('Tab 3', false, false, true, false, 'Tab 3 content'),
    new TabModel('Tab 4', false, true, true, false, 'Tab 4 content')
  ]);
  
  bool get applyAuthorStyles => true;
  
  AccordionPage.created() : super.created();
  
}

void main() {
  initPolymer();
  
  querySelectorAll('h-accordion').forEach((AccordionComponent accordion) {
    accordion.on['selected'].listen((CustomEvent event) {
      print('selected ${event.detail.header}');
    });
    
    accordion.on['deselected'].listen((CustomEvent event) {
      print('deselected ${event.detail.header}');
    });
  });
}