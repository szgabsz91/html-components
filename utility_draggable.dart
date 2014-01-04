import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  querySelectorAll('h-draggable').forEach((DraggableComponent draggable) {
    draggable.on['dropped'].listen((Event event) {
      print('dropped');
    });
  });
}