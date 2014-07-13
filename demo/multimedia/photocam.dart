import 'package:polymer/polymer.dart';
import '../showcase/item.dart';

@CustomTag('photocam-demo')
class PhotocamDemo extends ShowcaseItem {
  
  @observable bool audio = true;
  @observable String effect = '';
  
  PhotocamDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/multimedia/photocam.html', 'demo/multimedia/photocam.dart']);
  }
  
}