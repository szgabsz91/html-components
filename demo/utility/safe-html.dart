import 'package:polymer/polymer.dart';
import '../showcase/item.dart';

@CustomTag('safe-html-demo')
class SafeHtmlDemo extends ShowcaseItem {
  
  @observable String content = '<b>Hello <i>world</i>!</b>';
  
  SafeHtmlDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/utility/safe-html.html', 'demo/utility/safe-html.dart']);
  }
  
}