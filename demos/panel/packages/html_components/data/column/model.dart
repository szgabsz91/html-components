import 'package:polymer/polymer.dart';
import '../datatable/sort.dart';

class ColumnModel extends Object with Observable {
  @published String property;
  @published String type;
  @published String header;
  @published String content = '';
  @published String footer;
  @published String textAlign = 'left';
  @published bool sortable = false;
  @published bool filterable = false;
  @published bool editable = false;
  @published bool resizable = false;
  @published bool editing = false;
  @observable Sort sort;
  
  ColumnModel(this.property, this.type, this.header, this.content, this.footer,
      this.textAlign, this.sortable, this.filterable, this.editable,
      this.resizable, this.editing);
}