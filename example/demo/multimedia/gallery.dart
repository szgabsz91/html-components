import 'package:polymer/polymer.dart';
import '../showcase/item.dart';

@CustomTag('gallery-demo')
class GalleryDemo extends ShowcaseItem {
  
  GalleryDemo.created() : super.created() {
    super.noscript = true;
    super.setCodeSamples(const ['demo/multimedia/gallery.html']);
  }
  
}