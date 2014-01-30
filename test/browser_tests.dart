library browser_tests;

import 'package:unittest/html_enhanced_config.dart';
import 'package:polymer/polymer.dart';
import 'panel/tests.dart' as panel;
import 'utility/tests.dart' as utility;

void main() {
  useHtmlEnhancedConfiguration();
  
  initPolymer();
  
  panel.main();
  utility.main();
}