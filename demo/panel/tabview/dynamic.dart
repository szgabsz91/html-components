import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show TabModel, TabviewComponent, GrowlComponent;

@CustomTag('tabview-dynamic-demo')
class TabviewDynamicDemo extends ShowcaseItem {
  
  @observable List<TabModel> tabs = toObservable([
    new TabModel('Tab 1', false, false, true, false, 'Tab 1 content'),
    new TabModel('Tab 2', true, false, true, false, 'Tab 2 content'),
    new TabModel('Tab 3', false, false, true, false, 'Tab 3 content'),
    new TabModel('Tab 4', false, true, true, false, 'Tab 4 content')
  ]);
  
  TabviewDynamicDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/panel/tabview/dynamic.html', 'demo/panel/tabview/dynamic.dart']);
  }
  
  void onTabSelected(Event event, var detail, TabviewComponent target) {
    GrowlComponent.postMessage('Selected tab:', detail.header);
  }
  
  void onTabClosed(Event event, var detail, TabviewComponent target) {
    GrowlComponent.postMessage('Closed tab:', detail.header);
  }
  
}