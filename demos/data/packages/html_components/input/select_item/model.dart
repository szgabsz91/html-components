import 'package:polymer/polymer.dart';

class SelectItemModel extends Object with Observable {
  @observable String label;
  @observable String value;
  @observable bool selected;
  
  SelectItemModel(this.label, this.value, this.selected);
}