library column;

import "package:web_ui/web_ui.dart";
import "dart:html";

part "column/model.dart";

class ColumnComponent extends WebComponent {
  ColumnModel model = new ColumnModel();
  
  DivElement get _hiddenArea => this.query(".x-column_ui-helper-hidden");
  Element get _header => _hiddenArea.query("header");
  Element get _footer => _hiddenArea.query("footer");
  Element get _content => _hiddenArea.children.isEmpty ? null : _hiddenArea.children.first;
  
  void inserted() {
    if (_header != null) {
      model.header = _header.innerHtml;
      _header.remove();
    }
    
    if (_footer != null) {
      model.footer = _footer.innerHtml;
      _footer.remove();
    }
    
    if (_content != null) {
      model.content = _content.innerHtml;
      _refreshContent();
    }
    
    _hiddenArea.remove();
  }
  
  String get property => model.property;
  set property(String property) {
    model.property = property;
    _refreshContent();
  }
  
  String get type => model.type;
  set type(String type) => model.type = type;
  
  String get textalign => model.textAlign;
  set textalign(String textalign) => model.textAlign = textalign;
  
  bool get sortable => model.sortable;
  set sortable(var sortable) {
    if (sortable is bool) {
      model.sortable = sortable;
    }
    else if (sortable is String) {
      model.sortable = sortable == "true";
    }
    else {
      throw new ArgumentError("The sortable property must be of type bool or String!");
    }
  }
  
  bool get filterable => model.filterable;
  set filterable(var filterable) {
    if (filterable is bool) {
      model.filterable = filterable;
    }
    else if (filterable is String) {
      model.filterable = filterable == "true";
    }
    else {
      throw new ArgumentError("The filterable property must be of type bool or String!");
    }
  }
  
  bool get editable => model.editable;
  set editable(var editable) {
    if (editable is bool) {
      model.editable = editable;
    }
    else if (editable is String) {
      model.editable = editable == "true";
    }
    else {
      throw new ArgumentError("The editable property must be of type bool or String!");
    }
  }
  
  bool get resizable => model.resizable;
  set resizable(var resizable) {
    if (resizable is bool) {
      model.resizable = resizable;
    }
    else if (resizable is String) {
      model.resizable = resizable == "true";
    }
    else {
      throw new ArgumentError("The resizable property must be of type bool or String!");
    }
  }
  
  void _refreshContent() {
    if (model.content == "") {
      model.content = "\${${model.property}}";
    }
    else {
      model.content = model.content.replaceAll(r"${value}", "\${${model.property}}");
    }
  }
}