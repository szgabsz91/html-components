import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  DivElement div = new DivElement();
  div.style
    ..width = '${window.screen.width > document.body.clientWidth ? window.screen.width : document.body.clientWidth}px'
    ..height = '${window.screen.height > document.body.clientHeight ? window.screen.height : document.body.clientHeight}px'
    ..position = 'fixed'
    ..top = '0'
    ..left = '0'
    ..zIndex = '-1';
  document.body.children.insert(0, div);
  
  querySelectorAll('h-resizable').forEach((ResizableComponent resizable) {
    resizable.on['resized'].listen((Event event) {
      print('resized');
    });
  });
}