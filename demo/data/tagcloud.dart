import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show TagcloudComponent, GrowlComponent;

@CustomTag('tagcloud-demo')
class TagcloudDemo extends ShowcaseItem {
  
  TagcloudDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/tagcloud.html', 'demo/data/tagcloud.dart']);
  }
  
  void onTagSelected(CustomEvent event, var detail, TagcloudComponent target) {
    GrowlComponent.postMessage('Tag selected:', detail.label);
  }
  
}