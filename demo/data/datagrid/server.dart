import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatagridComponent, GrowlComponent;
import '../../../data/car.dart' as data;

@CustomTag('datagrid-server-demo')
class DatagridServerDemo extends ShowcaseItem with data.CarConverter {
  
  @observable String paginator = 'top';
  
  DatagridServerDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/datagrid/server.html', 'demo/data/datagrid/server.dart', 'data/car.dart']);
  }
  
  void onItemSelected(CustomEvent event, var detail, DatagridComponent target) {
    GrowlComponent.postMessage('Selected car:', carToString(detail));
  }
  
}