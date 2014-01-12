import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import '../../data/test_data.dart' as data;

@CustomTag('carousel-demo')
class CarouselDemo extends PolymerElement {
  
  @observable List<data.Car> cars = toObservable(data.cars.take(12).toList(growable: false));
  
  bool get applyAuthorStyles => true;
  
  CarouselDemo.created() : super.created();
  
  void onItemSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Selected car:', _detailToString(detail));
  }
  
  String _detailToString(var detail) {
    String manufacturer = '';
    String model = '';
    
    if (detail is Map) {
      manufacturer = detail['manufacturer'];
      model = detail['model'];
    }
    else if (detail is data.Car) {
      manufacturer = detail.manufacturer;
      model = detail.model;
    }
    
    return '$manufacturer ($model)';
  }
  
}