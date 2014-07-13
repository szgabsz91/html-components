import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';

@CustomTag('carousel-images-demo')
class CarouselImagesDemo extends ShowcaseItem {
  
  CarouselImagesDemo.created() : super.created() {
    super.noscript = true;
    super.setCodeSamples(const ['demo/data/carousel/images.html']);
  }
  
}