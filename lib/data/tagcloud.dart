import 'package:polymer/polymer.dart';
import 'dart:html';
import 'tag.dart';

@CustomTag('h-tagcloud')
class TagcloudComponent extends PolymerElement {
  
  @published int width = 250;
  
  @observable List<TagModel> tags = toObservable([]);
  
  TagcloudComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    List<TagComponent> tagComponents = $['hidden'].querySelector('content').getDistributedNodes();
    
    tagComponents.forEach((TagComponent tag) {
      tags.add(tag.model);
    });
    
    $['hidden'].remove();
  }
  
  void onTagMouseOver(MouseEvent event, var detail, Element target) {
    target.classes.add('hover');
  }
  
  void onTagMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onTagClicked(MouseEvent event, var detail, Element target) {
    int tagIndex = target.parent.parent.children.indexOf(target.parent) - 1;
    TagModel tag = tags[tagIndex];
    
    if (!tag.isExternal) {
      event.preventDefault();
    }
    
    this.dispatchEvent(new CustomEvent('selected', detail: tag));
  }
  
}