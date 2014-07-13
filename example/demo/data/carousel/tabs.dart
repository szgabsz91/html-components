import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';

@CustomTag('carousel-tabs-demo')
class CarouselTabsDemo extends ShowcaseItem {
  
  CarouselTabsDemo.created() : super.created() {
    super.noscript = true;
    super.setCodeSamples(const ['demo/data/carousel/tabs.html']);
  }
  
}