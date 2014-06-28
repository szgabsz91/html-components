import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import '../common/reflection.dart';
import '../common/null_tree_sanitizer.dart';

@CustomTag('h-item-template')
class ItemTemplateComponent extends PolymerElement {
  
  @published String template = '';
  @published Object model;
  @published Map<String, String> customTemplates;
  
  ItemTemplateComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
  }
  
  String getSubstitutedString(Object object) {
    String record = template;
    
    RegExp regExp = new RegExp(r"(\${[^\$^\s]+})");
    List<String> placeholders = regExp.allMatches(template.replaceAll('%7B', '{').replaceAll('%7D', '}')).map((Match match) => match.group(0)).toList(growable: false);
    
    placeholders.forEach((String placeholder) {
      String propertyName = placeholder.substring(2, placeholder.length - 1);
      
      if (propertyName.contains(':') && customTemplates != null) {
        if (customTemplates.containsKey(placeholder)) {
          record = record.replaceAll(placeholder, customTemplates[placeholder]);
        }
      }
      else {
        var propertyValue = getPropertyValue(object, propertyName);
        record = record.replaceAll(placeholder, propertyValue.toString());
        record = record.replaceAll(placeholder.replaceAll('{', '%7B').replaceAll('}', '%7D'), propertyValue.toString());
      }
    });
    
    return record;
  }
  
  void templateChanged() {
    _refresh();
  }
  
  void modelChanged() {
    _refresh();
  }
  
  void customTemplatesChanged() {
    _refresh();
  }
  
  void _refresh() {
    if (template == null || template == '' || model == null) {
      return;
    }
    
    String substitutedString = getSubstitutedString(model);
    
    Element element = new Element.html('<span>${substitutedString}</span>', treeSanitizer: new NullTreeSanitizer());
    
    this.shadowRoot.children
      ..clear()
      ..add(element);
  }
  
}