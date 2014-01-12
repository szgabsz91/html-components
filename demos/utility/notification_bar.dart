import 'package:polymer/polymer.dart';

@CustomTag('notification-bar-demo')
class NotificationBarDemo extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  NotificationBarDemo.created() : super.created();
  
  void onShowButtonClicked() {
    $['notification-bar'].show();
  }
  
  void onHideButtonClicked() {
    $['notification-bar'].hide();
  }
  
}