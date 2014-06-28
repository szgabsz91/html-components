import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-dialog')
class DialogComponent extends PolymerElement {
  
  @published bool modal = false;
  @published bool closable = false;
  
  @observable String header = '';
  @observable int documentWidth = 0;
  @observable int documentHeight = 0;
  @observable int windowHeight = 0;
  @observable double top = 0.0;
  @observable double left = 0.0;
  @observable bool hidden = true;
  
  DialogComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    documentWidth = document.body.clientWidth;
    documentHeight = document.body.clientHeight;
    windowHeight = window.innerHeight;
    
    top = (windowHeight - $['container'].clientHeight) / 2;
    left = (documentWidth - $['container'].clientWidth) / 2;
    
    Element headerElement = $['hidden'].querySelector('content').getDistributedNodes().first;
    header = headerElement.innerHtml;
    headerElement.remove();
    
    $['hidden'].remove();
    
    hide();
    
    // Chrome stable CSS fix
    $['content'].style.marginTop = '0';
  }
  
  void show() {
    hidden = false;
    
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
  
  void onCloseThickClicked(MouseEvent event) {
    event.preventDefault();
    
    hide();
  }
  
}