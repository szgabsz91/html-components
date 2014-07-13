import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatatableComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('datatable-edit-demo')
class DatatableEditDemo extends ShowcaseItem {
  
  @observable List<data.Car> cars = toObservable(data.cars);
  
  DatatableEditDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/datatable/edit.html', 'demo/data/datatable/edit.dart', 'data/car.dart']);
  }
  
  void onItemEdited(Event event, var detail, DatatableComponent target) {
    GrowlComponent.postMessage('', 'Item edited!');
  }
  
}