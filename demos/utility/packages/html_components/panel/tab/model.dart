import 'package:polymer/polymer.dart';

class TabModel extends Object with Observable {
  @observable String header = "";
  @observable bool selected = false;
  @observable bool disabled = false;
  @observable bool closable = false;
  // TODO maybe this is not needed
  @observable bool closed = false;
  @observable String content = null;
  
  TabModel(this.header, this.selected, this.disabled, this.closable, this.closed, this.content);
  
  bool operator ==(TabModel other) =>
      header == other.header &&
      selected == other.selected &&
      disabled == other.disabled &&
      closable == other.closable &&
      closed == other.closed &&
      content == other.content;
}