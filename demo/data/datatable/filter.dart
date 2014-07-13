import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatatableComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('datatable-filter-demo')
class DatatableFilterDemo extends ShowcaseItem {
  
  @observable List<data.Car> cars = toObservable(data.cars);
  
  DatatableFilterDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/datatable/filter.html', 'demo/data/datatable/filter.dart', 'data/car.dart']);
  }
  
  void onColumnFiltered(Event event, var detail, DatatableComponent target) {
    GrowlComponent.postMessage('', 'Column filtered!');
  }
  
}