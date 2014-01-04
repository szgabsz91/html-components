import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  querySelectorAll('h-masked-input').forEach((MaskedInputComponent maskedInput) {
    maskedInput.on['valueChanged'].listen((Event event) {
      print('value changed: ${maskedInput.value}');
    });
  });
}