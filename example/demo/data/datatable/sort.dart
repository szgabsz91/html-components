import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatatableComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('datatable-sort-demo')
class DatatableSortDemo extends ShowcaseItem {
  
  @observable List<data.Car> cars = toObservable(data.cars);
  
  DatatableSortDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/datatable/sort.html', 'demo/data/datatable/sort.dart', 'data/car.dart']);
  }
  
  void onColumnSorted(CustomEvent event, var detail, DatatableComponent target) {
    GrowlComponent.postMessage('Sorted column:', detail);
  }
  
}