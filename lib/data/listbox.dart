import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-listbox')
class ListboxComponent extends PolymerElement {
  
  @published String sidebarPosition;
  @published String selection = 'single';
  @published String moveUpLabel = "Move Up";
  @published String moveTopLabel = "Move Top";
  @published String moveDownLabel = "Move Down";
  @published String moveBottomLabel = "Move Bottom";
  @published int width = 200;
  @published int height = 200;
  @published List data = toObservable([]);
  @published String template;
  @published String header;
  @published List selectedItems = toObservable([]);
  
  @observable int sidebarWidth = 0;
  
  bool _selectMultiple = false;
  
  ListboxComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    Element headerElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element && node.tagName == 'HEADER', orElse: () => null);
    if (headerElement != null) {
      header = headerElement.innerHtml;
      headerElement.remove();
    }
    
    Element templateElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element, orElse: () => null);
    if (templateElement != null) {
      template = templateElement.parent.innerHtml;
      templateElement.remove();
    }
    
    $['hidden'].remove();
    
    document.onKeyDown.listen(_onKeyDown);
    document.onKeyUp.listen(_onKeyUp);
  }
  
  void sidebarPositionChanged() {
    if (sidebarPosition == 'left' || sidebarPosition == 'right') {
      sidebarWidth = 41;
    }
    else {
      sidebarWidth = 0;
    }
  }
  
  void onButtonMouseOver(MouseEvent event, var detail, Element target) {
    if (target.classes.contains('disabled')) {
      return;
    }
    
    target.classes.add('hover');
  }
  
  void onButtonMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onUpButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    bool reordered = false;
    
    for (Object selectedItem in selectedItems) {
      int currentIndex = data.indexOf(selectedItem);
      
      if (currentIndex == 0) {
        continue;
      }
      
      reordered = true;
      
      data.remove(selectedItem);
      data.insert(currentIndex - 1, selectedItem);
    }
    
    if (reordered) {
      this.dispatchEvent(new Event('reordered'));
    }
  }
  
  void onTopButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    bool reordered = false;
    
    for (Object selectedItem in selectedItems.reversed) {
      int currentIndex = data.indexOf(selectedItem);
      
      if (currentIndex == 0) {
        continue;
      }
      
      data.remove(selectedItem);
      data.insert(0, selectedItem);
    }
    
    if (reordered) {
      this.dispatchEvent(new Event('reordered'));
    }
  }
  
  void onDownButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    bool reordered = false;
    
    for (Object selectedItem in selectedItems) {
      int currentIndex = data.indexOf(selectedItem);
      
      if (currentIndex == data.length - 1) {
        continue;
      }
      
      reordered = true;
      
      data.remove(selectedItem);
      data.insert(currentIndex + 1, selectedItem);
    }
    
    if (reordered) {
      this.dispatchEvent(new Event('reordered'));
    }
  }
  
  void onBottomButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    bool reordered = false;
    
    for (Object selectedItem in selectedItems) {
      int currentIndex = data.indexOf(selectedItem);
      
      if (currentIndex == data.length - 1) {
        continue;
      }
      
      reordered = true;
      
      data.remove(selectedItem);
      data.add(selectedItem);
    }
    
    if (reordered) {
      this.dispatchEvent(new Event('reordered'));
    }
  }
  
  void onItemMouseOver(MouseEvent event, var detail, Element target) {
    int itemIndex = target.parent.children.indexOf(target) - 1;
    Object item = data[itemIndex];
    
    if (selectedItems.contains(item)) {
      return;
    }
    
    target.classes.add('hover');
  }
  
  void onItemMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onItemClicked(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    int itemIndex = target.parent.children.indexOf(target) - 1;
    Object item = data[itemIndex];
    
    if (selection == 'multiple') {
      if (_selectMultiple) {
        if (selectedItems.contains(item)) {
          List newList = toObservable([]);
          newList.addAll(selectedItems);
          newList.remove(item);
          selectedItems = newList;
        }
        else {
          List newList = toObservable([]);
          newList.addAll(selectedItems);
          newList.add(item);
          selectedItems = newList;
        }
      }
      else {
        if (!selectedItems.contains(item)) {
          selectedItems = toObservable([item]);
        }
        else {
          selectedItems = toObservable([]);
        }
      }
    }
    else {
      if (selectedItems.contains(item)) {
        selectedItems = toObservable([]);
      }
      else {
        selectedItems = toObservable([item]);
      }
    }
    
    this.dispatchEvent(new Event('selected'));
  }
  
  void _onKeyDown(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      _selectMultiple = true;
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      _selectMultiple = false;
    }
  }
  
}