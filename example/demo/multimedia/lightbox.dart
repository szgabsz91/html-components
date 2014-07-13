import 'package:polymer/polymer.dart';
import '../showcase/item.dart';

@CustomTag('lightbox-demo')
class LightboxDemo extends ShowcaseItem {
  
  LightboxDemo.created() : super.created() {
    super.noscript = true;
    super.setCodeSamples(const ['demo/multimedia/lightbox.html']);
  }
  
}