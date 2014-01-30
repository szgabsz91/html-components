import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

@CustomTag('confirmation-dialog-demo')
class ConfirmationDialogDemo extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  ConfirmationDialogDemo.created() : super.created();
  
  void showAlertConfirmationDialog() {
    $['alert'].show();
  }
  
  void showInfoConfirmationDialog() {
    $['info'].show();
  }
  
  void onButtonClicked(CustomEvent event, var detail, Element target) {
    GrowlComponent.postMessage('Button clicked:', detail);
  }
  
}