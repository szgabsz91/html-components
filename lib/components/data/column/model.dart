part of column;

@observable
class ColumnModel {
  String property;
  String _type;
  String header;
  String content = "";
  String footer;
  String _textAlign = "left";
  bool sortable = false;
  bool filterable = false;
  bool editable = false;
  bool resizable = false;
  bool editing = false;
  
  String get type => _type;
  set type(String type) {
    if (["string", "numeric", "boolean"].contains(type)) {
      _type = type;
    }
    else {
      throw new ArgumentError("The type property must be string, numeric or boolean!");
    }
  }
  
  SafeHtml get safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
  
  SafeHtml get safeContent => new SafeHtml.unsafe("<span>${content}</span>");
  
  SafeHtml get safeFooter => new SafeHtml.unsafe("<span>${footer}</span>");
  
  String get textAlign => _textAlign;
  set textAlign(String textAlign) {
    if (["left", "center", "right"].contains(textAlign)) {
      _textAlign = textAlign;
    }
    else {
      throw new ArgumentError("The textAlign property must be left, center or right!");
    }
  }
}