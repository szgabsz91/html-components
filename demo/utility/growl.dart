import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show GrowlComponent;

@CustomTag('growl-demo')
class GrowlDemo extends ShowcaseItem {
  
  @observable String summary = '';
  @observable String detail = '';
  @observable String severity = 'info';
  
  GrowlDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/utility/growl.html', 'demo/utility/growl.dart']);
  }
  
  void onPostButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    GrowlComponent.postMessage(summary, detail, severity);
    
    summary = '';
    detail = '';
    severity = 'info';
  }
  
}