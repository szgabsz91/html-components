import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  querySelectorAll('h-panel').forEach((PanelComponent panel) {
    panel.on['closed'].listen((Event event) {
      print('closed');
    });
    
    panel.on['toggled'].listen((CustomEvent event) {
      if (event.detail == 'HIDDEN') {
        print('hidden');
      }
      else {
        print('visible');
      }
    });
  });
}