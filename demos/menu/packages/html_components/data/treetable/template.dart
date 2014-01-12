import '../../common/reflection.dart' as reflection;

class TreetableTemplateManager {
  String _template;
  List<String> _placeholders;
  
  TreetableTemplateManager(String template) {
    this._template = template.replaceAllMapped(new RegExp(r"<img[^>]*(>)"), (Match match) {
      String target = match.group(0);
      return target.substring(0, target.length - 1) + "/>";
    });
    
    RegExp regExp = new RegExp(r"(\${[^\$^\s]+})");
    _placeholders = regExp.allMatches(template).map((Match match) => match.group(0)).toList(growable: false);
  }
  
  String get template => _template;
  List<String> get placeholders => _placeholders;
  
  String getSubstitutedString(Object object) {
    String record = template;
    
    placeholders.forEach((String placeholder) {
      String propertyName = placeholder.substring(2, placeholder.length - 1);
      
      if (propertyName.contains(":")) {
        return;
      }
      
      var propertyValue = reflection.getPropertyValue(object, propertyName);
      record = record.replaceAll(placeholder, propertyValue.toString());
    });
    
    return record;
  }
}