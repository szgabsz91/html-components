import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show Size, GrowlComponent;
import '../showcase/item.dart';

@CustomTag('resizable-demo')
class ResizableDemo extends ShowcaseItem {
  
  @observable bool aspectRatio = false;
  @observable bool ghost = false;
  @observable bool sizeConstraints = false;
  @observable Size minSize = null;
  @observable Size maxSize = null;
  
  ResizableDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/utility/resizable.html', 'demo/utility/resizable.dart']);
  }
  
  void sizeConstraintsChanged(Event event, var detail, Element target) {
    if (minSize == null && maxSize == null) {
      minSize = new Size(100, 100);
      maxSize = new Size(500, 500);
    }
    else {
      minSize = null;
      maxSize = null;
    }
  }
  
  void onResizableResized() {
    GrowlComponent.postMessage('', 'Resizable resized!');
  }
  
}