import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatatableComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('datatable-resizable-column-demo')
class DatatableResizableColumnDemo extends ShowcaseItem {
  
  @observable List<data.Car> cars = toObservable(data.cars);
  
  DatatableResizableColumnDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/datatable/resizable-column.html', 'demo/data/datatable/resizable-column.dart', 'data/car.dart']);
  }
  
  void onColumnResized(Event event, var detail, DatatableComponent target) {
    GrowlComponent.postMessage('', 'Column resized!');
  }
  
}