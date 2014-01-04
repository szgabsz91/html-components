import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-context-menu')
class ContextMenuComponent extends PolymerElement {
  
  @published String attachedTo;
  
  @observable int top = 0;
  @observable int left = 0;
  
  static List<String> _attachedIdList = [];
  
  ContextMenuComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    document.onContextMenu.listen((MouseEvent event) => event.preventDefault());
    
    document.onMouseUp.listen((MouseEvent event) {
      $['context-menu-container'].classes.add('hidden');
      
      if (event.button != 2) {
        return;
      }
      
      Element target = event.target;
      String targetId = target.id;
      
      if (attachedTo != null && targetId != attachedTo ||
          attachedTo == null && _attachedIdList.contains(targetId)) {
        return;
      }
      
      top = event.client.y;
      left = event.client.x;
      // In Chrome, top and left styles not updating
      $['context-menu-container'].style
        ..top = '${top}px'
        ..left = '${left}px';
      
      $['context-menu-container'].classes.remove('hidden');
    });
    
    if (attachedTo != null) {
      if (_attachedIdList.contains(attachedTo)) {
        _attachedIdList.remove(attachedTo);
      }
      
      _attachedIdList.add(attachedTo);
    }
  }
  
}