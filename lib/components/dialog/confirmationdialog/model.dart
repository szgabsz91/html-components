part of confirmationdialog;

@observable
class ConfirmationDialogModel {
  bool modal = false;
  bool closable = true;
  String header = "";
  String message = "";
  String _severity = "alert";
  Size documentSize = new Size.zero();
  int windowHeight;
  double top;
  double left;
  bool hidden = true;
  
  SafeHtml get _safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
  
  SafeHtml get _safeMessage => new SafeHtml.unsafe("<span>${message}</span>");
  
  // TODO severity enum - maybe common with growl? only one class?
  String get severity => _severity;
  set severity(String severity) => _severity = severity;
}