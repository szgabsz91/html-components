import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'package:html_components/html_components.dart' show StringToInt;

@CustomTag('clock-demo')
class ClockDemo extends ShowcaseItem {
  
  @observable int size = 270;
  
  final StringToInt asInteger = new StringToInt();
  
  ClockDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/utility/clock.html', 'demo/utility/clock.dart']);
  }
  
}