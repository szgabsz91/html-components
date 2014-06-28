import 'package:polymer/polymer.dart';

class Person extends Object with Observable {
  @observable String firstName;
  @observable String lastName;
  
  Person(this.firstName, this.lastName);
}

@CustomTag('item-template-demo')
class ItemTemplateDemo extends PolymerElement {
  
  @observable Person person = new Person('John', 'Doe');
  
  ItemTemplateDemo.created() : super.created();
  
}