library selectlistbox;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "../common/templates.dart";

part "selectlistbox/model.dart";

class SelectListboxComponent extends WebComponent {
  SelectListboxModel model = new SelectListboxModel();
  
  DivElement get _hiddenArea => this.query(".x-selectlistbox_ui-helper-hidden");
  TemplateElement get _templateElement => _hiddenArea.query("template");
  TableRowElement _getListItemByIndex(int index) {
    return this.queryAll(".x-selectlistbox_ui-selectlistbox-list tbody tr").elementAt(index);
  }
  
  static const EventStreamProvider<Event> _CHANGED_EVENT = const EventStreamProvider<Event>("changed");
  Stream<Event> get onChanged => _CHANGED_EVENT.forTarget(this);
  static _dispatchChangedEvent(Element element) {
    element.dispatchEvent(new Event("changed"));
  }
  
  void inserted() {
    if (_templateElement != null) {
      model._templateManager = new TemplateManager(_templateElement.innerHtml);
    }
    
    _hiddenArea.remove();
    
    document.onKeyDown.listen(_onKeyDown);
    document.onKeyUp.listen(_onKeyUp);
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
        model.items = items.substring(1, items.length - 1).split(", ");
      }
    }
    else {
      throw new ArgumentError("The items property must be of type List or String!");
    }
  }
  
  String get selection => model.selection;
  set selection(String selection) => model.selection = selection;
  
  int get width => model.width;
  set width(var width) {
    if (width is int) {
      model.width = width;
    }
    else if (width is String) {
      model.width = int.parse(width);
    }
    else {
      throw new ArgumentError("The width property must be of type int or String!");
    }
  }
  
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
    if (model.selectedItems.contains(item)) {
      return;
    }
    
    int index = model.items.indexOf(item);
    TableRowElement listItem = _getListItemByIndex(index);
    
    listItem.classes.add("x-selectlistbox_ui-state-hover");
  }
  
  void _onMouseOut(Object item) {
    if (model.selectedItems.contains(item)) {
      return;
    }
    
    int index = model.items.indexOf(item);
    TableRowElement listItem = _getListItemByIndex(index);
    
    listItem.classes.remove("x-selectlistbox_ui-state-hover");
  }
  
  void _onClicked(Object item, MouseEvent event) {
    event.preventDefault();
    
    if (model.selection == "multiple") {
      if (model._selectMultiple) {
        if (model.selectedItems.contains(item)) {
          model.selectedItems.remove(item);
        }
        else {
          model.selectedItems.add(item);
        }
      }
      else {
        if (!model.selectedItems.contains(item)) {
          model.selectedItems.clear();
          model.selectedItems.add(item);
        }
        else {
          model.selectedItems.clear();
        }
      }
    }
    else {
      if (model.selectedItem == item) {
        model.selectedItem = null;
      }
      else {
        model.selectedItem = item;
      }
    }
    
    int index = model.items.indexOf(item);
    TableRowElement listItem = _getListItemByIndex(index);
    listItem.classes.remove("x-selectlistbox_ui-state-hover");
    
    _dispatchChangedEvent(this);
  }
  
  void _onKeyDown(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._selectMultiple = true;
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._selectMultiple = false;
    }
  }
  
  SafeHtml _getItemAsHtml(Object item) {
    String htmlString = "";
    
    if (model._templateManager == null) {
      htmlString = item.toString();
    }
    else {
      htmlString = model._templateManager.getSubstitutedString(item);
    }
    
    return new SafeHtml.unsafe("<span>$htmlString</span>");
  }
}