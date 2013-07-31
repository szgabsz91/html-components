library selectbutton;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "selectitem.dart";

part "selectbutton/model.dart";

class SelectButtonComponent extends WebComponent {
  SelectButtonModel model = new SelectButtonModel();
  
  List<DivElement> get _selectItemElements => this.queryAll('div[is="x-selectitem"]');
  
  static const EventStreamProvider<Event> _SELECT_CHANGED_EVENT = const EventStreamProvider<Event>("selectChanged");
  Stream<Event> get onSelectChanged => _SELECT_CHANGED_EVENT.forTarget(this);
  static void _dispatchSelectChangedEvent(Element element) {
    element.dispatchEvent(new Event("selectChanged"));
  }
  
  void inserted() {
    DivElement selectItemElementFirst = _selectItemElements.first;
    SelectItemComponent selectItemComponentFirst = selectItemElementFirst.xtag;
    selectItemComponentFirst.setLeftCornerRounded();
    
    DivElement selectItemElementLast = _selectItemElements.last;
    SelectItemComponent selectItemComponentLast = selectItemElementLast.xtag;
    selectItemComponentLast.setRightCornerRounded();
    
    _selectItemElements.forEach((DivElement selectItemElement) {
      SelectItemComponent selectItemComponent = selectItemElement.xtag;
      bool dispatchEvent = false;
      
      selectItemComponent.onSelectChanged.listen((Event event) {
        _onSelectionChanged(selectItemComponent);
        event.preventDefault();
      });
    });
  }
  
  String get selection => model.selection;
  set selection(String selection) {
    model.selection = selection;
    _refreshSelections();
  }
  
  void _onSelectionChanged(SelectItemComponent selectItemComponent) {
    SelectItemModel selectItemModel = selectItemComponent.model;
    
    if (model.selection == "single") {
      if (selectItemModel.selected) {
        if (model._selectedItems.isNotEmpty) {
          model._selectedItems.first.model.selected = false;
          model._selectedItems.clear();
        }
        
        model._selectedItems.add(selectItemComponent);
      }
      else {
        model._selectedItems.remove(selectItemComponent);
      }
    }
    else {
      if (selectItemComponent.model.selected) {
        model._selectedItems.add(selectItemComponent);
      }
      else {
        model._selectedItems.remove(selectItemComponent);
      }
    }
  }
  
  void _refreshSelections() {
    bool foundSelected = false;
    
    _selectItemElements.forEach((DivElement selectItemElement) {
      SelectItemComponent selectItemComponent = selectItemElement.xtag;
      
      if (model.selection == "single") {
        if (foundSelected) {
          selectItemComponent.selected = false;
        }
        else if (selectItemComponent.model.selected) {
          foundSelected = true;
          model._selectedItems.add(selectItemComponent);
        }
      }
      else {
        if (selectItemComponent.model.selected) {
          model._selectedItems.add(selectItemComponent);
        }
      }
    });
  }
}