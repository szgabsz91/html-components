library contextmenu;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "common/menu.dart";
import "menubar.dart";

part "contextmenu/model.dart";

class ContextMenuComponent extends WebComponent {
  ContextMenuModel model = new ContextMenuModel();
  
  static List<String> _attachedIdList = [];
  
  DivElement get _contextMenu => this.query(".x-contextmenu_menu-root");
  DivElement get _menubarElement => this.query('div[is="x-menubar"]');
  MenubarComponent get _menubarComponent => _menubarElement.xtag;
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _SELECTED_EVENT.forTarget(this);
  static _dispatchSelectedEvent(Element element, String label) {
    SelectEventDetail detail = new SelectEventDetail(label);
    element.dispatchEvent(new CustomEvent("selected", detail: detail.toString()));
  }
  
  void inserted() {
    document.onContextMenu.listen((MouseEvent event) => event.preventDefault());
    
    document.onMouseUp.listen((MouseEvent event) {
      _contextMenu.classes.add("x-contextmenu_ui-helper-hidden");
      
      if (event.button != 2) {
        return;
      }
      
      Element target = event.target;
      String targetId = target.id;
      
      if (model.attachedTo != null && targetId != model.attachedTo ||
          model.attachedTo == null && _attachedIdList.contains(targetId)) {
        return;
      }
      
      model._top = event.client.y;
      model._left = event.client.x;
      
      _contextMenu.classes.remove("x-contextmenu_ui-helper-hidden");
    });
    
    _menubarComponent.onSelected.listen((CustomEvent event) {
      event.preventDefault();
      event.stopPropagation();
      _dispatchSelectedEvent(this, event.detail);
    });
  }
  
  String get attachedto => model.attachedTo;
  set attachedto(String attachedto) {
    if (model.attachedTo != null && _attachedIdList.contains(model.attachedTo)) {
      _attachedIdList.remove(model.attachedTo);
    }
    
    model.attachedTo = attachedto;
    _attachedIdList.add(model.attachedTo);
  }
}