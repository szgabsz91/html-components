library picklist;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "../common/templates.dart";

part "picklist/model.dart";

class PicklistComponent extends WebComponent {
  PicklistModel model = new PicklistModel();
  
  DivElement get _hiddenArea => this.query(".x-picklist_ui-helper-hidden");
  List<Element> get _headerElements => _hiddenArea.queryAll("header");
  Element get _sourceHeaderElement => _headerElements.length > 0 ?_headerElements.first : null;
  Element get _targetHeaderElement => _headerElements.length > 1 ? _headerElements.elementAt(1) : null;
  TemplateElement get _templateElement => _hiddenArea.query("template");
  LIElement _getSourceListItemByIndex(int index) {
    return this.queryAll(".ui-picklist-source .x-picklist_ui-picklist-item").elementAt(index);
  }
  LIElement _getTargetListItemByIndex(int index) {
    return this.queryAll(".ui-picklist-target .x-picklist_ui-picklist-item").elementAt(index);
  }
  
  static const EventStreamProvider<Event> _CHANGED_EVENT = const EventStreamProvider<Event>("changed");
  Stream<Event> get onChanged => _CHANGED_EVENT.forTarget(this);
  static _dispatchChangedEvent(Element element) {
    element.dispatchEvent(new Event("changed"));
  }
  
  void inserted() {
    if (_sourceHeaderElement != null) {
      model.sourceHeader = _sourceHeaderElement.innerHtml;
    }
    
    if (_targetHeaderElement != null) {
      model.targetHeader = _targetHeaderElement.innerHtml;
    }
    
    if (_templateElement != null) {
      model._templateManager = new TemplateManager(_templateElement.innerHtml);
    }
    
    _hiddenArea.remove();
  }
  
  List<Object> get items => model.items;
  set items(var items) {
    if (items is List) {
      // List set from code
      model.items = items;
    }
    else if (items is String) {
      RegExp regExp = new RegExp(r"\[(.*)\]");
      
      if (regExp.hasMatch(items)) {
        // Bound list
        model.items = toObservable(items.substring(1, items.length - 1).split(", "));
      }
    }
    else {
      throw new ArgumentError("The items property must be of type List or String!");
    }
  }
  
  String get addlabel => model.addLabel;
  set addlabel(String addlabel) => model.addLabel = addlabel;
  
  String get addalllabel => model.addAllLabel;
  set addalllabel(String addalllabel) => model.addAllLabel = addalllabel;
  
  String get removelabel => model.removeLabel;
  set removelabel(String removelabel) => model.removeLabel = removelabel;
  
  String get removealllabel => model.removeAllLabel;
  set removealllabel(String removealllabel) => model.removeAllLabel = removealllabel;
  
  int get height => model.height;
  set height(var height) {
    if (height is int) {
      model.height = height;
    }
    else if (height is String) {
      model.height = int.parse(height);
    }
    else {
      throw new ArgumentError("The height property must be of type int or String!");
    }
  }
  
  void _onMouseOver(Object item) {
    if (item == model._selectedSourceItem || item == model._selectedTargetItem) {
      return;
    }
    
    int sourceIndex = model.items.indexOf(item);
    int targetIndex = model.pickedItems.indexOf(item);
    LIElement listItem;
    
    if (sourceIndex > -1) {
      listItem = _getSourceListItemByIndex(sourceIndex);
    }
    else if (targetIndex > -1) {
      listItem = _getTargetListItemByIndex(targetIndex);
    }
    
    listItem.classes.add("x-picklist_ui-state-hover");
  }
  
  void _onMouseOut(Object item) {
    if (item == model._selectedSourceItem || item == model._selectedTargetItem) {
      return;
    }
    
    int sourceIndex = model.items.indexOf(item);
    int targetIndex = model.pickedItems.indexOf(item);
    LIElement listItem;
    
    if (sourceIndex > -1) {
      listItem = _getSourceListItemByIndex(sourceIndex);
    }
    else if (targetIndex > -1) {
      listItem = _getTargetListItemByIndex(targetIndex);
    }
    
    listItem.classes.remove("x-picklist_ui-state-hover");
  }
  
  void _onClicked(Object item, MouseEvent event) {
    event.preventDefault();
    
    int sourceIndex = model.items.indexOf(item);
    int targetIndex = model.pickedItems.indexOf(item);
    
    if (sourceIndex > -1) {
      LIElement listItem = _getSourceListItemByIndex(sourceIndex);
      listItem.classes.remove("x-picklist_ui-state-hover");
      model._selectedSourceItem = item;
    }
    else if (targetIndex > -1) {
      LIElement listItem = _getTargetListItemByIndex(targetIndex);
      listItem.classes.remove("x-picklist_ui-state-hover");
      model._selectedTargetItem = item;
    }
  }
  
  void _onMouseOverButton(MouseEvent event) {
    if (event.target is TableCellElement) {
      return;
    }
    
    ButtonElement target = event.currentTarget;
    target.classes.add("x-picklist_ui-state-hover");
  }
  
  void _onMouseOutButton(MouseEvent event) {
    if (event.target is TableCellElement) {
      return;
    }
    
    ButtonElement target = event.currentTarget;
    target.classes.remove("x-picklist_ui-state-hover");
  }
  
  void _onAddClicked(MouseEvent event) {
    event.preventDefault();
    
    Object selectedSourceItem = model._selectedSourceItem;
    
    if (selectedSourceItem == null) {
      return;
    }
    
    model.items.remove(selectedSourceItem);
    model.pickedItems.add(selectedSourceItem);
    
    model._selectedSourceItem = null;
    
    _dispatchChangedEvent(this);
  }
  
  void _onAddAllClicked(MouseEvent event) {
    event.preventDefault();
    
    if (model.items.isEmpty) {
      return;
    }
    
    model.pickedItems.addAll(model.items);
    model.items.clear();
    
    _dispatchChangedEvent(this);
  }
  
  void _onRemoveClicked(MouseEvent event) {
    event.preventDefault();
    
    Object selectedTargetItem = model._selectedTargetItem;
    
    if (selectedTargetItem == null) {
      return;
    }
    
    model.items.add(selectedTargetItem);
    model.pickedItems.remove(selectedTargetItem);
    
    model._selectedTargetItem = null;
    
    _dispatchChangedEvent(this);
  }
  
  void _onRemoveAllClicked(MouseEvent event) {
    event.preventDefault();
    
    if (model.pickedItems.isEmpty) {
      return;
    }
    
    model.items.addAll(model.pickedItems);
    model.pickedItems.clear();
    
    _dispatchChangedEvent(this);
  }
  
  SafeHtml _getItemAsHtml(Object item) {
    String htmlString = "";
    
    if (model._templateManager == null) {
      htmlString = item.toString();
    }
    else {
      htmlString = model._templateManager.getSubstitutedString(item);
    }
    
    return new SafeHtml.unsafe("<span>${htmlString}</span>");
  }
}