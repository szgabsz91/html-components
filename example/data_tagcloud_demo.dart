import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('tagcloud-demo')
class TagcloudDemo extends PolymerElement {
  
  TagcloudDemo.created() : super.created();
  
  void onTagSelected(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Tag selected:', detail.label);
  }
  
}