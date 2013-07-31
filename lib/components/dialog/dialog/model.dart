part of dialog;

@observable
class DialogModel {
  bool modal = false;
  bool closable = true;
  String header = "";
  Size documentSize = new Size.zero();
  int windowHeight;
  double top;
  double left;
  bool hidden = true;
  
  SafeHtml get _safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
}