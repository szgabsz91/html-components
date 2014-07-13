import 'package:polymer/polymer.dart';

class User extends Object with Observable {
  @observable String username;
  @observable String password;
  
  User([this.username = '', this.password = '']);
}