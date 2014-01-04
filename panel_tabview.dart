import 'package:polymer/polymer.dart';
import 'dart:html';

export 'package:polymer/init.dart';

@CustomTag('tabview-demo')
class TabviewDemo extends PolymerElement {
  
  TabviewDemo.created() : super.created();
  
  void onTabSelected(Event event, var detail, Node target) {
    print('Selected tab: ${detail.header}');
  }
  
  void onTabClosed(Event event, var detail, Node target) {
    print('Closed tab: ${detail.header}');
  }
  
}