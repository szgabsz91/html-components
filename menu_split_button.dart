import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  querySelectorAll('h-split-button').forEach((SplitButtonComponent splitButton) {
    splitButton.on['selected'].listen((CustomEvent event) {
      print('selected ${event.detail}');
    });
  });
}