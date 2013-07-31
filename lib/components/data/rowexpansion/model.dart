part of rowexpansion;

@observable
class RowExpansionModel {
  String content = "";
  
  SafeHtml get _safeContent => new SafeHtml.unsafe("<div>${content}</div>");
}