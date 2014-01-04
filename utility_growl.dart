import 'package:polymer/polymer.dart';
import 'package:html_components/html_components.dart';
import 'dart:html';
import 'dart:async';

void main() {
  initPolymer();
  
  int index = 0;
  List<String> severities = ['info', 'warn', 'error', 'fatal'];
  
  document.querySelector('button').onClick.listen((MouseEvent _) {
    GrowlComponent.postMessage('summary ${index}', 'detail ${index}', severities[index % 4]);
    index++;
  });
}