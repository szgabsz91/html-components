import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

class User extends Object with Observable {
  @observable String username;
  @observable String password;
  
  User([this.username = '', this.password = '']);
}

@CustomTag('dialog-demo')
class DialogDemo extends PolymerElement {
  
  @observable User user1 = new User();
  @observable User user2 = new User();
  
  bool get applyAuthorStyles => true;
  
  DialogDemo.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    $['loginButton1'].onClick.listen((MouseEvent event) {
      onLoginButtonClicked(user1, $['nonmodal']);
      event.preventDefault();
    });
    
    $['loginButton2'].onClick.listen((MouseEvent event) {
      onLoginButtonClicked(user2, $['modal']);
      event.preventDefault();
    });
  }
  
  void showNonModalDialog() {
    $['nonmodal'].show();
  }
  
  void showModalDialog() {
    $['modal'].show();
  }
  
  // Exception: type 'DialogComponent' is not a subtype of type 'DialogComponent' of 'dialog'.
  void onLoginButtonClicked(User user, var dialog) {
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
    
    dialog.hide();
  }
  
}