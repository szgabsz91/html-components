library tagcloud;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "tag.dart";

part "tagcloud/model.dart";

class TagcloudComponent extends WebComponent {
  TagcloudModel model = new TagcloudModel();
  
  DivElement get _hiddenArea => this.query(".x-tagcloud_ui-helper-hidden");
  List<DivElement> get _tagElements => _hiddenArea.queryAll('div[is="x-tag"]');
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("selected", detail: label));
  }
  
  void inserted() {
    _tagElements.forEach((Element tagElement) {
      TagComponent tagComponent = tagElement.xtag;
      model.tags.add(tagComponent.model);
    });
    
    _hiddenArea.remove();
  }
  
  int get width => model.width;
  set width(var width) {
    if (width is int) {
      model.width = width;
    }
    else if (width is String) {
      model.width = int.parse(width);
    }
    else {
      throw new ArgumentError("The width property must be of type int or String!");
    }
  }
  
  void _onMouseOver(MouseEvent event) {
    AnchorElement target = event.target;
    target.classes.add("x-tagcloud_ui-state-hover");
  }
  
  void _onMouseOut(MouseEvent event) {
    AnchorElement target = event.target;
    target.classes.remove("x-tagcloud_ui-state-hover");
  }
  
  void _onClicked(TagModel tag, MouseEvent event) {
    if (!tag.isExternal) {
      event.preventDefault();
    }
    
    AnchorElement target = event.target;
    String label = target.text;
    _dispatchSelectedEvent(this, label);
  }
}