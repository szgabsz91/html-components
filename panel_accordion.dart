import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

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