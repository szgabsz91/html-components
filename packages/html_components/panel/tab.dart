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
  void enteredView() {
    super.enteredView();
    
    ContentElement contentElement = $['hidden'].querySelector('content');
    List nodes = contentElement.getDistributedNodes();
    
    if (nodes.isNotEmpty) {
      content = nodes.first.parent.innerHtml;
    }
    
    $['hidden'].remove();
  }
  
  TabModel get model => new TabModel(header, selected, disabled, closable, closed, content);
}