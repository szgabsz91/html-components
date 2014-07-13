import 'package:polymer_expressions/filter.dart';

class StringToInt extends Transformer<String, int> {
  
  String forward(int value) => '$value';
  
  int reverse(String string) => string == null ? null : int.parse(string);
  
}