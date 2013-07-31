part of panel;

@observable
class PanelModel {
  bool closable = false;
  bool toggleable = false;
  String header;
  String content;
  String footer;
  
  SafeHtml get _safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
  
  SafeHtml get _safeContent => new SafeHtml.unsafe("<span>${content}</span>");
  
  SafeHtml get _safeFooter => new SafeHtml.unsafe("<span>${footer}</span>");
  
  bool get _hasFooter => footer != null;
}