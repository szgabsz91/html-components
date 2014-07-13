import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

@CustomTag('h-confirmation-dialog')
class ConfirmationDialogComponent extends PolymerElement {
  
  @published bool modal = false;
  @published bool closable = false;
  @published String severity = 'alert';
  
  @observable String header = '';
  @observable String message = '';
  @observable int documentWidth = 0;
  @observable int documentHeight = 0;
  @observable int windowHeight = 0;
  @observable double top = 0.0;
  @observable double left = 0.0;
  @observable bool hidden = true;
  
  ConfirmationDialogComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    _refreshSize();
    
    List<ButtonElement> buttons = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is ButtonElement).toList(growable: false);
    
    buttons.forEach((ButtonElement button) {
      SpanElement buttonContent = new SpanElement();
      buttonContent.text = button.text;
      
      button
        ..classes.add('button')
        ..text = ''
        ..onClick.listen((_) => onButtonClicked(button.text))
        ..onMouseOver.listen((_) => button.classes.add('hover'))
        ..onMouseOut.listen((_) => button.classes.remove('hover'))
        ..children.add(buttonContent);
      
      $['button-container'].children.add(button);
    });
    
    Element headerElement = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is Element && node.tagName == 'HEADER').first;
    header = headerElement.innerHtml;
    headerElement.remove();
    
    message = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is Element).first.parent.innerHtml;
    
    $['hidden'].remove();
    
    hide();
  }
  
  void modalChanged() {
    if (modal && !hidden) {
      $['overlay'].classes.remove('hidden');
    }
  }
  
  void show() {
    hidden = false;
    
    scheduleMicrotask(_refreshSize);
    
    $['container'].classes.remove('hidden');
    
    if (modal) {
      $['overlay'].classes.remove('hidden');
    }
  }
  
  void hide() {
    hidden = true;
    
    $['container'].classes.add('hidden');
    $['overlay'].classes.add('hidden');
  }
  
  void onButtonClicked(String label) {
    this.dispatchEvent(new CustomEvent('buttonclicked', detail: label));
    
    hide();
  }
  
  void onCloseThickClicked(MouseEvent event) {
    event.preventDefault();
    
    hide();
  }
  
  void _refreshSize() {
    documentWidth = document.body.clientWidth;
    documentHeight = document.body.clientHeight;
    windowHeight = window.innerHeight;
    
    top = (windowHeight - $['container'].clientHeight) / 2;
    left = (documentWidth - $['container'].clientWidth) / 2;
  }
  
}