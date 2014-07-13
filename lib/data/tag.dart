import 'package:polymer/polymer.dart';
import 'tag/model.dart';

export 'tag/model.dart';

@CustomTag('h-tag')
class TagComponent extends PolymerElement {
  
  @published String label = '';
  @published String url = '#';
  @published String target = '_self';
  @published int strength = 1;
  
  TagComponent.created() : super.created();
  
  TagModel get model => new TagModel(label, url, target, strength);
  
}