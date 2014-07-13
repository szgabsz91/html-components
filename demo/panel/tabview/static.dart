import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show TabviewComponent, GrowlComponent;

@CustomTag('tabview-static-demo')
class TabviewStaticDemo extends ShowcaseItem {
  
  @observable String orientation = 'top';
  
  TabviewStaticDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/panel/tabview/static.html', 'demo/panel/tabview/static.dart']);
  }
  
  void onTabSelected(Event event, var detail, TabviewComponent target) {
    GrowlComponent.postMessage('Selected tab:', detail.header);
  }
  
}