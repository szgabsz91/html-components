import 'package:polymer/polymer.dart';

@CustomTag('safe-html-demo')
class SafeHtmlDemo extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  SafeHtmlDemo.created() : super.created();
  
}