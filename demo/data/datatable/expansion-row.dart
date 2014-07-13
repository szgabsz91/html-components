import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatatableComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('datatable-expansion-row-demo')
class DatatableExpansionRowDemo extends ShowcaseItem with data.CarConverter {
  
  @observable List<data.Car> cars = toObservable(data.cars);
  
  DatatableExpansionRowDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/datatable/expansion-row.html', 'demo/data/datatable/expansion-row.dart', 'data/car.dart']);
  }
  
  void onRowToggled(Event event, var detail, DatatableComponent target) {
    GrowlComponent.postMessage('', 'Row toggled!');
  }
  
}