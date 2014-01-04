import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  querySelectorAll('h-boolean-button').forEach((BooleanButtonComponent booleanButton) {
    booleanButton.on['valueChanged'].listen((Event event) {
      print('value changed: ${booleanButton.pressed}');
    });
  });
}