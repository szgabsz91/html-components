import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

export 'package:polymer/init.dart';

@CustomTag('tabview-demo')
class TabviewDemo extends PolymerElement {
  
  @observable List<TabModel> tabs = toObservable([
    new TabModel('Tab 1', false, false, true, false, 'Tab 1 content'),
    new TabModel('Tab 2', true, false, true, false, 'Tab 2 content'),
    new TabModel('Tab 3', false, false, true, false, 'Tab 3 content'),
    new TabModel('Tab 4', false, true, true, false, 'Tab 4 content')
  ]);
  
  TabviewDemo.created() : super.created();
  
  void onTabSelected(Event event, var detail, Node target) {
    print('Selected tab: ${detail.header}');
  }
  
  void onTabClosed(Event event, var detail, Node target) {
    print('Closed tab: ${detail.header}');
  }
  
}