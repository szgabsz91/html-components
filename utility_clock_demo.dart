import 'package:polymer/polymer.dart';
import 'package:polymer_expressions/filter.dart';

class StringToInt extends Transformer<String, int> {
  String forward(int value) => '$value';
  int reverse(String string) => string == null ? null : int.parse(string);
}

@CustomTag('clock-demo')
class ClockDemo extends PolymerElement {
  
  @observable int size = 270;
  
  final Transformer asInteger = new StringToInt();
  
  bool get applyAuthorStyles => true;
  
  ClockDemo.created() : super.created();
  
}