import 'package:polymer/polymer.dart';
import 'dart:html';
import '../common/null_tree_sanitizer.dart';

@CustomTag('h-safe-html')
class SafeHtmlComponent extends PolymerElement {
  
  @published String content = '';
  @published Map<String, String> customTemplates = toObservable({});
  
  SafeHtmlComponent.created() : super.created();
  
  void contentChanged() {
    _refresh();
  }
  
  void customTemplatesChanged() {
    _refresh();
  }
  
  void _refresh() {
    String substitutedString = getSubstitutedString();
    
    Element element = new Element.html('<span>${substitutedString}</span>', treeSanitizer: new NullTreeSanitizer());
    
    $['templateRoot'].children
      ..clear()
      ..add(element);
  }
  
  String getSubstitutedString() {
    String record = content;
    
    for (String key in customTemplates.keys) {
      record = record.replaceAll(key, customTemplates[key]);
    }
    
    return record;
  }
  
}