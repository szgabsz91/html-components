import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DialogComponent, GrowlComponent;
import '../../data/user.dart' as data;

@CustomTag('dialog-demo')
class DialogDemo extends ShowcaseItem {
  
  @observable bool closable = true;
  @observable bool modal = true;
  @observable data.User user = new data.User();
  
  DialogDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/dialog/dialog.html', 'demo/dialog/dialog.dart', 'data/user.dart']);
  }
  
  void open(MouseEvent event, var detail, ButtonElement target) {
    event.preventDefault();
    $['dialog'].show();
  }
  
  void login(MouseEvent event, var detail, DialogComponent target) {
    event.preventDefault();
    
    if (user.username == '' || user.password == '') {
      return;
    }
    
    if (user.username == 'admin' && user.password == 'admin') {
      GrowlComponent.postMessage('Login successful!', 'Welcome, admin!');
    }
    else {
      GrowlComponent.postMessage('Login failed!', 'The username or password is incorrect!', 'warn');
    }
    
    user.username = '';
    user.password = '';
    
    $['dialog'].hide();
  }
  
}