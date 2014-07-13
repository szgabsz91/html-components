import 'package:polymer/polymer.dart';
import '../showcase/item.dart';

@CustomTag('notification-bar-demo')
class NotificationBarDemo extends ShowcaseItem {
  
  @observable bool visible = false;
  
  NotificationBarDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/utility/notification-bar.html', 'demo/utility/notification-bar.dart']);
  }
  
  void onShowButtonClicked() {
    $['notification-bar'].show();
    visible = true;
  }
  
  void onHideButtonClicked() {
    $['notification-bar'].hide();
    visible = false;
  }
  
}