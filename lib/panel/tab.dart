import 'package:polymer/polymer.dart';
import 'dart:html';
import 'tab/model.dart';

export 'tab/model.dart';

@CustomTag('h-tab')
class TabComponent extends PolymerElement {
  
  @published String header = '';
  @published bool selected = false;
  @published bool disabled = false;
  @published bool closable = false;
  @published bool closed = false;
  @published String content = null;
  
  TabComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    ContentElement contentElement = $['hidden'].querySelector('content');
    List<Element> elements = contentElement.getDistributedNodes().where((Node node) => node is Element).toList(growable: false);
    
    if (elements.isNotEmpty) {
      content = elements.first.parent.innerHtml;
    }
    
    $['hidden'].remove();
  }
  
  TabModel get model => new TabModel(header, selected, disabled, closable, closed, content);
}