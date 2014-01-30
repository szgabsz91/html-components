import 'package:polymer/polymer.dart';

class ImageModel extends Object with Observable {
  @observable String src;
  @observable String alt;
  @observable String title;
  @observable double opacity;
  @observable String visibility = 'visible';
  
  ImageModel(this.src, this.alt, this.title, [this.opacity = 1.0]);
}