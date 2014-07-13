import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show CarouselComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('carousel-server-demo')
class CarouselServerDemo extends ShowcaseItem with data.CarConverter {
  
  CarouselServerDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/carousel/server.html', 'demo/data/carousel/server.dart', 'data/car.dart']);
  }
  
  void onItemSelected(CustomEvent event, var detail, CarouselComponent target) {
    GrowlComponent.postMessage('Selected car:', carToString(detail));
  }
  
}