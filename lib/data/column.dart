import 'package:polymer/polymer.dart';
import 'dart:html';
import 'column/model.dart';

export 'column/model.dart';

@CustomTag('h-column')
class ColumnComponent extends PolymerElement {
  
  @published String property;
  @published String type;
  @published String header;
  @published String content = '';
  @published String footer;
  @published String textAlign = 'left';
  @published bool sortable = false;
  @published bool filterable = false;
  @published bool editable = false;
  @published bool resizable = false;
  @published bool editing = false;
  
  ColumnComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    List<Node> childNodes = $['hidden'].querySelector('content').getDistributedNodes();
    
    Element headerElement = childNodes.firstWhere((Node node) => node is Element && node.tagName == 'HEADER', orElse: () => null);
    if (headerElement != null) {
      header = headerElement.innerHtml;
      headerElement.remove();
    }
    
    Element footerElement = childNodes.firstWhere((Node node) => node is Element && node.tagName == 'FOOTER', orElse: () => null);
    if (footerElement != null) {
      footer = footerElement.innerHtml;
      footerElement.remove();
    }
    
    Element contentElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element, orElse: () => null);
    if (contentElement != null) {
      content = contentElement.parent.innerHtml;
    }
    
    if (content == '') {
      content = '\${${property}}';
    }
    else {
      content = content.replaceAll(r'${value}', '\${${property}}');
    }
    
    $['hidden'].remove();
  }
  
  ColumnModel get model => new ColumnModel(property, type, header, content, footer, textAlign, sortable, filterable, editable, resizable, editing);
  
}