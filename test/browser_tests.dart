library browser_tests;

import 'package:unittest/html_enhanced_config.dart';
import 'package:polymer/polymer.dart';
import 'utility/tests.dart' as utility;

void main() {
  useHtmlEnhancedConfiguration();
  
  initPolymer();
  
  utility.main();
}