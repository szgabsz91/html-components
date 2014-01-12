import 'package:polymer/polymer.dart';

class TagModel extends Object with Observable {
  @observable String label = '';
  @observable String url = '#';
  @observable int strength = 1;
  
  TagModel(this.label, this.url, this.strength);
  
  bool get isExternal => url != '#';
}