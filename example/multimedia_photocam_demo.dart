import 'package:polymer/polymer.dart';

@CustomTag('photocam-demo')
class PhotocamDemo extends PolymerElement {
  
  @observable bool audio = true;
  @observable String effect = '';
  
  PhotocamDemo.created() : super.created();
  
}