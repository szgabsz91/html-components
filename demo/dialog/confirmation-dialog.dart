import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show GrowlComponent;

@CustomTag('confirmation-dialog-demo')
class ConfirmationDialogDemo extends ShowcaseItem {
  
  @observable bool closable = true;
  @observable bool modal = true;
  @observable String severity = 'info';
  
  ConfirmationDialogDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/dialog/confirmation-dialog.html', 'demo/dialog/confirmation-dialog.dart']);
  }
  
  void open(MouseEvent event, var detail, ButtonElement target) {
    event.preventDefault();
    $['confirmationDialog'].show();
  }
  
  void onButtonClicked(CustomEvent event, var detail, ButtonElement target) {
    GrowlComponent.postMessage('Button clicked:', detail);
  }
  
}