import 'package:polymer/polymer.dart';
import '../showcase/collection.dart';

@CustomTag('carousel-demo')
class CarouselDemo extends ShowcaseCollection {
  
  CarouselDemo.created() : super.created() {
    super.hashPrefix = '/data/carousel';
    super.items = [
      new ItemModel('Client Data', 'client'),
      new ItemModel('Server Data', 'server'),
      new ItemModel('Tabs', 'tabs'),
      new ItemModel('Images', 'images')
    ];
  }
  
}