import 'package:polymer/polymer.dart';

class Size extends Object with Observable {
  @observable int width;
  @observable int height;
  
  Size(this.width, this.height);
}