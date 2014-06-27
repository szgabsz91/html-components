import 'package:polymer/polymer.dart';
import 'dart:html';
import '../common/reflection.dart';
import '../common/null_tree_sanitizer.dart';

@CustomTag('h-item-template')
class ItemTemplateComponent extends PolymerElement {
  
  @published String template = '';
  @published Object model;
  @published Map<String, String> customTemplates;
  bool loaded = false;
  
  bool get applyAuthorStyles => true;
  
  ItemTemplateComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    _refresh();
    
    loaded = true;
  }
  
  String getSubstitutedString(Object object) {
    String record = template;
    
    RegExp regExp = new RegExp(r"(\${[^\$^\s]+})");
    List<String> placeholders = regExp.allMatches(template).map((Match match) => match.group(0)).toList(growable: false);
    
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
      }
    });
    
    return record;
  }
  
  void templateChanged() {
    if (loaded) {
      _refresh();
    }
  }
  
  void modelChanged() {
    if (loaded) {
      _refresh();
    }
  }
  
  void customTemplatesChanged() {
    if (loaded) {
      _refresh();
    }
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