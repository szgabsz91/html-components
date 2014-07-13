import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show CarouselComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('carousel-client-demo')
class CarouselClientDemo extends ShowcaseItem with data.CarConverter {
  
  @observable List<data.Car> cars = toObservable(data.getCars(13));
  
  CarouselClientDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/carousel/client.html', 'demo/data/carousel/client.dart', 'data/car.dart']);
  }
  
  void onItemSelected(CustomEvent event, var detail, CarouselComponent target) {
    GrowlComponent.postMessage('Selected car:', carToString(detail));
  }
  
}