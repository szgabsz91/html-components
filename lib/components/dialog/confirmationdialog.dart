library confirmationdialog;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "../common/wrappers.dart";

part "confirmationdialog/model.dart";

class ConfirmationDialogComponent extends WebComponent {
  ConfirmationDialogModel model = new ConfirmationDialogModel();
  
  DivElement get _container => this.query(".x-confirmationdialog_ui-dialog");
  DivElement get _buttonContainer => this.query(".x-confirmationdialog_ui-dialog-buttonpane");
  DivElement get _hiddenArea => this.query(".x-confirmationdialog_ui-helper-hidden");
  Element get _header => _hiddenArea.query("header");
  List<ButtonElement> get _buttons => _hiddenArea.queryAll("button");
  
  void inserted() {
    model.documentSize.width = document.body.clientWidth;
    model.documentSize.height = document.body.clientHeight;
    model.windowHeight = window.innerHeight;
    
    model.top = (model.windowHeight - _container.clientHeight) / 2;
    model.left = (model.documentSize.width - _container.clientWidth) / 2;
    
    _buttons.forEach((ButtonElement button) {
      SpanElement buttonContent = new SpanElement();
      buttonContent
        ..classes.add("x-confirmationdialog_ui-button-text")
        ..text = button.text;
      
      button
        ..classes.addAll(["x-confirmationdialog_ui-button", "x-confirmationdialog_ui-state-default", "x-confirmationdialog_ui-corner-all", "x-confirmationdialog_ui-button-text-only"])
        ..text = ""
        ..onClick.listen((_) => hide())
        ..onMouseOver.listen((_) => button.classes.add("x-confirmationdialog_ui-state-hover"))
        ..onMouseOut.listen((_) => button.classes.remove("x-confirmationdialog_ui-state-hover"))
        ..children.add(buttonContent);
      
      _buttonContainer.children.add(button);
    });
    
    model.header = _header.innerHtml;
    _header.remove();
    
    model.message = _hiddenArea.innerHtml;
    
    _hiddenArea.remove();
  }
  
  bool get modal => model.modal;
  set modal(var modal) {
    if (modal is bool) {
      model.modal = modal;
    }
    else if (modal is String) {
      model.modal = modal == "true";
    }
    else {
      throw new ArgumentError("The modal property must be of type bool or String!");
    }
  }
  
  bool get closable => model.closable;
  set closable(var closable) {
    if (closable is bool) {
      model.closable = closable;
    }
    if (closable is String) {
      model.closable = closable == "true";
    }
    else {
      throw new ArgumentError("The closable property must be of type bool or String!");
    }
  }
  
  String get severity => model.severity;
  set severity(String severity) => model.severity = severity;
  
  void show() {
    model.hidden = false;
  }
  
  void hide() {
    model.hidden = true;
  }
  
  void _onCloseClicked(MouseEvent event) {
    event.preventDefault();
    hide();
  }
}