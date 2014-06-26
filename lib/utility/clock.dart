import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-clock')
class ClockComponent extends PolymerElement {
  
  @published int size = 270;
  
  ClockComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    DateTime date = new DateTime.now();
    
    int h = date.hour;
    h = h > 12 ? h - 12: h;
    int m = date.minute;
    int s = date.second;
    
    int second = 6 * s;
    double minute = (m + s / 60) * 6;
    double hour = (h + m / 60 + s / 3600) * 30;
    
    $['hour'].attributes['transform'] = 'rotate($hour)';
    $['minute'].attributes['transform'] = 'rotate($minute)';
    $['second'].attributes['transform'] = 'rotate($second)';
  }
  
}