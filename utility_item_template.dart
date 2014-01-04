import 'package:polymer/polymer.dart';

class Person extends Object with Observable {
  @observable String name;
  
  Person(this.name);
}

@CustomTag('item-template-page')
class ItemTemplatePage extends PolymerElement {
  
  @observable Person person = new Person('John');
  
  ItemTemplatePage.created() : super.created() {
    print('w');
  }
  
}

void main() {
  initPolymer();
}