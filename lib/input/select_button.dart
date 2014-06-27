import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'select_item.dart';

@CustomTag('h-select-button')
class SelectButtonComponent extends PolymerElement {
  
  @published String selection = 'single';
  
  @observable List<SelectItemComponent> _selectedItems = toObservable([]);
  
  SelectButtonComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    List<SelectItemComponent> selectItems = $['container'].querySelector('content').getDistributedNodes().where((Node node) => node is SelectItemComponent).toList(growable: false);
    
    bool foundSelected = false;
    
    selectItems.forEach((SelectItemComponent selectItem) {
      selectItem.style
        ..display = 'inline-block'
        ..marginRight = '-4px';
      
      if (selection == 'single') {
        if (foundSelected) {
          selectItem.selected = false;
        }
        else if (selectItem.selected) {
          foundSelected = true;
          _selectedItems.add(selectItem);
        }
      }
      else {
        if (selectItem.selected) {
          _selectedItems.add(selectItem);
        }
      }
      
      selectItem.on['valueChanged'].listen((Event event) {
        event.preventDefault();
        
        onItemValueChange(selectItem);
      });
    });
    
    selectItems.first.setLeftCornerRounded();
    selectItems.last.setRightCornerRounded();
  }
  
  List<SelectItemModel> get selectedItems => _selectedItems.map((SelectItemComponent component) => component.model).toList(growable: false);
  
  void onItemValueChange(SelectItemComponent selectItemComponent) {
    SelectItemModel selectItemModel = selectItemComponent.model;
    
    if (selection == 'single') {
      if (selectItemModel.selected) {
        if (_selectedItems.isNotEmpty) {
          _selectedItems.first.selected = false;
          _selectedItems.clear();
        }
        
        _selectedItems.add(selectItemComponent);
      }
      else {
        _selectedItems.remove(selectItemComponent);
      }
    }
    else {
      if (selectItemComponent.selected) {
        _selectedItems.add(selectItemComponent);
      }
      else {
        _selectedItems.remove(selectItemComponent);
      }
    }
    
    this.dispatchEvent(new Event('selectionchanged'));
  }
  
}