import 'package:polymer/polymer.dart';

@CustomTag('h-row-expansion')
class RowExpansionComponent extends PolymerElement {
  
  @published String content = '';
  
  RowExpansionComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    content = $['hidden'].querySelector('content').getDistributedNodes().first.parent.innerHtml;
    
    $['hidden'].remove();
  }
  
}