import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import '../../data/person.dart' as data;

@CustomTag('item-template-demo')
class ItemTemplateDemo extends ShowcaseItem {
  
  @observable String template = r'<b>Hello <i>${firstName}</i>!</b>';
  @observable data.Person person = new data.Person('John', 'Doe');
  
  ItemTemplateDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/utility/item-template.html', 'demo/utility/item-template.dart', 'data/person.dart']);
  }
  
}