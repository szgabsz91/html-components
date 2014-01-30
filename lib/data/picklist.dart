import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-picklist')
class PicklistComponent extends PolymerElement {
  
  @published List data = toObservable([]);
  @published String addLabel = 'Add';
  @published String addAllLabel = 'Add All';
  @published String removeLabel = 'Remove';
  @published String removeAllLabel = 'Remove All';
  @published int width = 202;
  @published int height = 202;
  @published bool order = false;
  @published String selection = 'single';
  
  @observable String sourceHeader;
  @observable String targetHeader;
  @observable String template;
  
  @observable List sourceSelectedItems = toObservable([]);
  @observable List targetSelectedItems = toObservable([]);
  @observable List pickedItems = toObservable([]);
  
  // calculated fields
  @observable String sourceSidebarPosition;
  @observable String targetSidebarPosition;
  
  PicklistComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    Element sourceHeaderElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element && node.tagName == 'HEADER', orElse: () => null);
    if (sourceHeaderElement != null) {
      sourceHeader = sourceHeaderElement.innerHtml;
      sourceHeaderElement.remove();
    }
    
    Element targetHeaderElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element && node.tagName == 'HEADER', orElse: () => null);
    if (targetHeaderElement != null) {
      targetHeader = targetHeaderElement.innerHtml;
      targetHeaderElement.remove();
    }
    
    Element templateElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element, orElse: () => null);
    if (templateElement != null) {
      template = templateElement.parent.innerHtml;
      templateElement.remove();
    }
    
    $['hidden'].remove();
  }
  
  void orderChanged() {
    if (order) {
      sourceSidebarPosition = 'left';
      targetSidebarPosition = 'right';
    }
    else {
      sourceSidebarPosition = 'none';
      targetSidebarPosition = 'none';
    }
  }
  
  void onButtonMouseOver(MouseEvent event, var detail, Element target) {
    target.classes.add('hover');
  }
  
  void onButtonMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onAddButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    for (Object sourceItem in sourceSelectedItems) {
      data.remove(sourceItem);
      pickedItems.add(sourceItem);
    }
    
    sourceSelectedItems = toObservable([]);
    
    this.shadowRoot.querySelectorAll('button').forEach((ButtonElement button) {
      onButtonMouseOut(null, null, button);
    });
    
    this.dispatchEvent(new Event('picked'));
  }
  
  void onAddAllButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    pickedItems.addAll(data);
    data = toObservable([]);
    sourceSelectedItems = toObservable([]);
    
    this.shadowRoot.querySelectorAll('button').forEach((ButtonElement button) {
      onButtonMouseOut(null, null, button);
    });
    
    this.dispatchEvent(new Event('picked'));
  }
  
  void onRemoveButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    for (Object targetItem in targetSelectedItems) {
      pickedItems.remove(targetItem);
      data.add(targetItem);
    }
    
    targetSelectedItems = toObservable([]);
    
    this.shadowRoot.querySelectorAll('button').forEach((ButtonElement button) {
      onButtonMouseOut(null, null, button);
    });
    
    this.dispatchEvent(new Event('picked'));
  }
  
  void onRemoveAllButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    data.addAll(pickedItems);
    pickedItems = toObservable([]);
    targetSelectedItems = toObservable([]);
    
    this.shadowRoot.querySelectorAll('button').forEach((ButtonElement button) {
      onButtonMouseOut(null, null, button);
    });
    
    this.dispatchEvent(new Event('picked'));
  }
  
}