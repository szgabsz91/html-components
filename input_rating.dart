import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  querySelectorAll('h-rating').forEach((RatingComponent rating) {
    rating.on['valueChanged'].listen((Event event) {
      print('value changed: ${rating.value}');
    });
  });
}