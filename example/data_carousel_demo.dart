import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

class Car {
  String model;
  String manufacturer;
  int year;
  bool warranty;
  
  Car(String this.model, String this.manufacturer, int this.year, bool this.warranty);
  
  String get imagePath => "${manufacturer}.jpg";
  
  String toString() => model;
}

@CustomTag('carousel-demo')
class CarouselDemo extends PolymerElement {
  
  @observable List<Car> cars = toObservable([
    new Car("107f6514", "Honda", 2012, true),
    new Car("4c182d41", "Audi", 1965, false),
    new Car("b32ff478", "Chrysler", 1990, true),
    new Car("9a657f4d", "Ferrari", 2005, false),
    new Car("e79e04ac", "Opel", 2002, false),
    new Car("c26b4bdd", "Mercedes", 1968, true),
    new Car("0f7c6bf8", "Mercedes", 2005, false),
    new Car("2e18d596", "Honda", 1988, false),
    new Car("55f8ae33", "Opel", 1985, false),
    new Car("ead885f7", "Volkswagen", 2005, false),
    new Car("b4d60a09", "BMW", 1995, false),
    new Car("bf503dea", "Opel", 2006, false),
    new Car("09edd664", "Volvo", 1976, false)
  ]);
  
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
    else if (detail is Car) {
      manufacturer = detail.manufacturer;
      model = detail.model;
    }
    
    return '$manufacturer ($model)';
  }
  
}