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

List<Car> _cars = [
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
  new Car("09edd664", "Volvo", 1976, false),
  new Car("004dfda3", "Chrysler", 1999, false),
  new Car("48dccaa5", "Mercedes", 1983, true),
  new Car("a2d920ab", "Audi", 1971, true),
  new Car("e392f591", "Mercedes", 2005, false),
  new Car("9585cac1", "Mercedes", 2008, true),
  new Car("13e9e1bf", "Honda", 1990, true),
  new Car("ef4e526a", "Ferrari", 1972, false),
  new Car("439f21a7", "BMW", 1996, false),
  new Car("19924a3b", "Ferrari", 1990, true),
  new Car("c371ca0d", "Opel", 1996, false),
  new Car("3a5f1d0b", "BMW", 1973, true),
  new Car("7b966c83", "Volkswagen", 2008, false),
  new Car("76ca3f21", "Opel", 1983, true),
  new Car("0865717f", "Honda", 1972, false),
  new Car("ae7a37f5", "Ferrari", 1976, false),
  new Car("dfe81f5a", "Opel", 1991, true),
  new Car("8e001e99", "Volvo", 1976, false),
  new Car("edfecf6d", "Opel", 1975, false),
  new Car("1968e984", "Honda", 1989, false),
  new Car("cae24651", "BMW", 1974, false),
  new Car("b9fe01bb", "Renault", 2001, true),
  new Car("b45964f6", "Renault", 2005, true),
  new Car("039040ee", "Volkswagen", 1976, true),
  new Car("395a1c95", "Chrysler", 2003, false),
  new Car("71d3e760", "Chrysler", 2003, true),
  new Car("ff12cf33", "BMW", 1983, true),
  new Car("e6590710", "Ferrari", 2009, true),
  new Car("27da1304", "Honda", 1987, true),
  new Car("bff9afd9", "Volvo", 1976, true),
  new Car("a77b396f", "Mercedes", 1971, false),
  new Car("e51d6ab0", "Ferrari", 1961, true),
  new Car("dd9dc756", "Volkswagen", 2003, false),
  new Car("b46bd077", "Chrysler", 1963, false),
  new Car("92aa8974", "Renault", 1991, true),
  new Car("ba8d99b6", "Volvo", 2003, true),
  new Car("193808e9", "Volvo", 1967, true),
  new Car("5ab07802", "Chrysler", 1975, true)
];

@CustomTag('datagrid-demo')
class DatagridDemo extends PolymerElement {
  
  @observable List<Car> cars = toObservable(_cars);
  @observable List<Car> carsSmall = toObservable(_cars.take(9).toList(growable: false));
  
  bool get applyAuthorStyles => true;
  
  DatagridDemo.created() : super.created();
  
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