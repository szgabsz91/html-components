import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  querySelector('h-feed-reader').on['refreshed'].listen((Event event) {
    print('refreshed');
  });
}