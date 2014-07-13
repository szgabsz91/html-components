import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-context-menu')
class ContextMenuComponent extends PolymerElement {
  
  @published String attachedTo;
  @published bool disabled = false;
  
  @observable int top = 0;
  @observable int left = 0;
  
  StreamSubscription<CustomEvent> _contextMenuListener;
  StreamSubscription<CustomEvent> _targetListener;
  StreamSubscription<CustomEvent> _documentListener;
  
  ContextMenuComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    this._contextMenuListener = document.onContextMenu.listen((MouseEvent event) {
      if (!disabled) {
        event.preventDefault();
      }
    });
    
    if (attachedTo != null) {
      var target = document.querySelector('body /deep/ #${attachedTo}');
      
      if (target != null) {
        this._targetListener = target.onMouseUp.listen(mouseUpListener);
      }
    }
    else {
      this._documentListener = document.onMouseUp.listen(mouseUpListener);
    }
  }
  
  @override
  void detached() {
    super.detached();
    
    this._contextMenuListener.cancel();
    this._contextMenuListener = null;
    if (this._targetListener != null) {
      this._targetListener.cancel();
      this._targetListener = null;
    }
    if (this._documentListener != null) {
      this._documentListener.cancel();
      this._documentListener = null;
    }
  }
  
  void mouseUpListener(MouseEvent event) {
    document.querySelectorAll('body /deep/ h-context-menu::shadow #context-menu-container').forEach((DivElement container) => container.classes.add('hidden'));
    
    if (disabled || event.button != 2) {
      return;
    }
    
    event
      ..stopPropagation()
      ..preventDefault();
    
    var contextMenu = $['context-menu-container'];
    
    contextMenu.style
      ..top = '${event.client.y}px'
      ..left = '${event.client.x}px';
    contextMenu.classes.remove('hidden');
  }
  
}