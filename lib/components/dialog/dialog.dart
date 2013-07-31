library dialog;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "../common/wrappers.dart";

part "dialog/model.dart";

class DialogComponent extends WebComponent {
  DialogModel model = new DialogModel();
  
  DivElement get _container => this.query(".x-dialog_ui-dialog");
  DivElement get _hiddenArea => this.query(".x-dialog_ui-helper-hidden");
  Element get _header => _hiddenArea.query("header");
  
  void inserted() {
    model.documentSize.width = document.body.clientWidth;
    model.documentSize.height = document.body.clientHeight;
    model.windowHeight = window.innerHeight;
    
    model.top = (model.windowHeight - _container.clientHeight) / 2;
    model.left = (model.documentSize.width - _container.clientWidth) / 2;
    
    model.header = _header.innerHtml;
    _header.remove();
    
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
    else if (closable is String) {
      model.closable = closable == "true";
    }
    else {
      throw new ArgumentError("The closable property must be of type bool or String!");
    }
  }
  
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