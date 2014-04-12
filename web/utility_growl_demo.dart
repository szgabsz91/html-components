import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('growl-demo')
class GrowlDemo extends PolymerElement {
  
  @observable String summary = '';
  @observable String detail = '';
  @observable String severity = 'info';
  
  bool get applyAuthorStyles => true;
  
  GrowlDemo.created() : super.created();
  
  void onPostButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    GrowlComponent.postMessage(summary, detail, severity);
    
    summary = '';
    detail = '';
    severity = 'info';
  }
  
}