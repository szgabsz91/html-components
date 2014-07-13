import 'package:polymer/polymer.dart';
import '../showcase/item.dart';

@CustomTag('image-compare-demo')
class ImageCompareDemo extends ShowcaseItem {
  
  ImageCompareDemo.created() : super.created() {
    super.noscript = true;
    super.setCodeSamples(const ['demo/multimedia/image-compare.html']);
  }
  
}