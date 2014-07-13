import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatagridComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('datagrid-client-demo')
class DatagridClientDemo extends ShowcaseItem with data.CarConverter {
  
  @observable List<data.Car> cars = toObservable(data.cars);
  @observable String paginator = 'top';
  
  DatagridClientDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/datagrid/client.html', 'demo/data/datagrid/client.dart', 'data/car.dart']);
  }
  
  void onItemSelected(CustomEvent event, var detail, DatagridComponent target) {
    GrowlComponent.postMessage('Selected car:', carToString(detail));
  }
  
}