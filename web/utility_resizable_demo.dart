import 'package:polymer/polymer.dart';
import 'package:html_components/html_components.dart';

@CustomTag('resizable-demo')
class ResizableDemo extends PolymerElement {
  
  @observable bool aspectRatio = false;
  @observable bool ghost = false;
  
  bool get applyAuthorStyles => true;
  
  ResizableDemo.created() : super.created();
  
  void onResizableResized() {
    GrowlComponent.postMessage('', 'Resizable resized!');
  }
  
}