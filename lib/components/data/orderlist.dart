library orderlist;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "../common/templates.dart";

part "orderlist/model.dart";

class OrderlistComponent extends WebComponent {
  OrderlistModel model = new OrderlistModel();
  
  static const EventStreamProvider<Event> _CHANGED_EVENT = const EventStreamProvider<Event>("changed");
  Stream<Event> get onChanged => _CHANGED_EVENT.forTarget(this);
  static _dispatchChangedEvent(Element element) {
    element.dispatchEvent(new Event("changed"));
  }
  
  DivElement get _hiddenArea => this.query(".x-orderlist_ui-helper-hidden");
  Element get _headerElement => _hiddenArea.query("header");
  TemplateElement get _templateElement => _hiddenArea.query("template");
  LIElement _getListItemByIndex(int index) {
    return this.queryAll(".x-orderlist_ui-orderlist-item").elementAt(index);
  }
  
  void inserted() {
    if (_headerElement != null) {
      model.header = _headerElement.innerHtml;
    }
    
    if (_templateElement != null) {
      model._templateManager = new TemplateManager(_templateElement.innerHtml);
    }
    
    _hiddenArea.remove();
  }
  
  List get items => model.items;
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
  
  String get moveuplabel => model.moveUpLabel;
  set moveuplabel(String moveuplabel) => model.moveUpLabel = moveuplabel;
  
  String get movetoplabel => model.moveTopLabel;
  set movetoplabel(String movetoplabel) => model.moveTopLabel = movetoplabel;
  
  String get movedownlabel => model.moveDownLabel;
  set movedownlabel(String movedownlabel) => model.moveDownLabel = movedownlabel;
  
  String get movebottomlabel => model.moveBottomLabel;
  set movebottomlabel(String movebottomlabel) => model.moveBottomLabel = movebottomlabel;
  
  void _onMouseOver(Object item) {
    if (item == model._selectedItem) {
      return;
    }
    
    int index = model.items.indexOf(item);
    LIElement listItem = _getListItemByIndex(index);
    listItem.classes.add("x-orderlist_ui-state-hover");
  }
  
  void _onMouseOut(Object item) {
    if (item == model._selectedItem) {
      return;
    }
    
    int index = model.items.indexOf(item);
    LIElement listItem = _getListItemByIndex(index);
    listItem.classes.remove("x-orderlist_ui-state-hover");
  }
  
  void _onClicked(Object item, MouseEvent event) {
    event.preventDefault();
    
    int index = model.items.indexOf(item);
    LIElement listItem = _getListItemByIndex(index);
    listItem.classes.remove("x-orderlist_ui-state-hover");
    
    model._selectedItem = item;
  }
  
  void _onMouseOverButton(MouseEvent event) {
    ButtonElement target = event.currentTarget;
    target.classes.add("x-orderlist_ui-state-hover");
  }
  
  void _onMouseOutButton(MouseEvent event) {
    ButtonElement target = event.currentTarget;
    target.classes.remove("x-orderlist_ui-state-hover");
  }
  
  void _onUpClicked(MouseEvent event) {
    event.preventDefault();
    
    Object selectedItem = model._selectedItem;
    
    if (selectedItem == null) {
      return;
    }
    
    int currentIndex = model.items.indexOf(selectedItem);
    
    if (currentIndex == 0) {
      return;
    }
    
    model.items.remove(selectedItem);
    model.items.insert(currentIndex - 1, selectedItem);
    
    _dispatchChangedEvent(this);
  }
  
  void _onTopClicked(MouseEvent event) {
    event.preventDefault();
    
    Object selectedItem = model._selectedItem;
    
    if (selectedItem == null) {
      return;
    }
    
    int currentIndex = model.items.indexOf(selectedItem);
    
    if (currentIndex == 0) {
      return;
    }
    
    model.items.remove(selectedItem);
    model.items.insert(0, selectedItem);
    
    _dispatchChangedEvent(this);
  }
  
  void _onDownClicked(MouseEvent event) {
    event.preventDefault();
    
    Object selectedItem = model._selectedItem;
    
    if (selectedItem == null) {
      return;
    }
    
    int currentIndex = model.items.indexOf(selectedItem);
    
    if (currentIndex == model.items.length - 1) {
      return;
    }
    
    model.items.remove(selectedItem);
    model.items.insert(currentIndex + 1, selectedItem);
    
    _dispatchChangedEvent(this);
  }
  
  void _onBottomClicked(MouseEvent event) {
    event.preventDefault();
    
    Object selectedItem = model._selectedItem;
    
    if (selectedItem == null) {
      return;
    }
    
    int currentIndex = model.items.indexOf(selectedItem);
    
    if (currentIndex == model.items.length - 1) {
      return;
    }
    
    model.items.remove(selectedItem);
    model.items.add(selectedItem);
    
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