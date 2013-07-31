library tag;

import "package:web_ui/web_ui.dart";

part "tag/model.dart";

class TagComponent extends WebComponent {
  TagModel model = new TagModel();
  
  String get label => model.label;
  set label(String label) => model.label = label;
  
  String get url => model.url;
  set url(String url) => model.url = url;
  
  int get strength => model.strength;
  set strength(var strength) {
    if (strength is int) {
      model.strength = strength;
    }
    else if (strength is String) {
      model.strength = int.parse(strength);
    }
    else {
      throw new ArgumentError("The strength property must be of type int or String!");
    }
  }
}