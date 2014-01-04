import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

void main() {
  initPolymer();
  
  NotificationBarComponent notificationBar = querySelector('h-notification-bar');
  ButtonElement button = querySelector('button');
  
  button.onClick.listen((MouseEvent event) {
    if (button.text == 'Show') {
      notificationBar.show();
      button.text = 'Hide';
    }
    else {
      notificationBar.hide();
      button.text = 'Show';
    }
  });
}