import 'package:polymer/polymer.dart';
import 'dart:html';
import 'select_item.dart';

export 'select_item.dart';

@CustomTag('h-select-checkbox-menu')
class SelectCheckboxMenuComponent extends PolymerElement {
  
  @published String label;
  
  String _queryExpression = '';
  @observable List<SelectItemModel> items = toObservable([]);
  @observable List<SelectItemModel> visibleItems = toObservable([]);
  
  // This could be implemented with a filter?
  @observable String get queryExpression => _queryExpression;
  void set queryExpression(String queryExpression) {
    _queryExpression = queryExpression;
    
    visibleItems.clear();
    visibleItems.addAll(
      items
        .where((SelectItemModel item) => item.label.toLowerCase().startsWith(queryExpression.toLowerCase()))
        .toList(growable: false)
    );
  }
  
  List<SelectItemModel> get selectedItems {
    return items.where((SelectItemModel item) => item.selected)
                .toList(growable: false);
  }
  
  SelectCheckboxMenuComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    List<SelectItemComponent> selectItems = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is SelectItemComponent).toList(growable: false);
    
    selectItems.forEach((SelectItemComponent selectItem) {
      items.add(selectItem.model);
    });
    
    queryExpression = '';
    
    $['hidden'].remove();
  }
  
  void onButtonMouseOver() {
    $['button'].classes.add('hover');
  }
  
  void onButtonMouseOut() {
    $['button'].classes.remove('hover');
  }
  
  void onButtonClicked(MouseEvent event) {
    event.preventDefault();
    
    $['panel'].classes.toggle('hidden');
  }
  
  void onCloseThickClicked(MouseEvent event) {
    event.preventDefault();
    
    $['panel'].classes.add('hidden');
  }
  
  void onSelectAllCheckboxClicked() {
    if ($['select-all-checkbox'].querySelector('div').classes.contains('checked')) {
      deselectAll();
    }
    else {
      selectAll();
    }
    
    this.dispatchEvent(new Event('selectionchanged'));
  }
  
  void onSelectItemClicked(MouseEvent event, var detail, Element target) {
    SelectItemModel selectItem = visibleItems[target.parent.children.indexOf(target) - 1];
    
    if (selectItem.selected) {
      deselect(selectItem);
    }
    else {
      select(selectItem);
    }
    
    this.dispatchEvent(new Event('selectionchanged'));
  }
  
  void selectAll() {
    $['select-all-checkbox'].querySelector('div').classes.add('checked');
    $['select-all-checkbox'].querySelector('div span').classes.add('icon-check');
    visibleItems.forEach((SelectItemModel item) => item.selected = true);
  }
  
  void deselectAll() {
    $['select-all-checkbox'].querySelector('div').classes.remove('checked');
    $['select-all-checkbox'].querySelector('div span').classes.remove('icon-check');
    visibleItems.forEach((SelectItemModel item) => item.selected = false);
  }
  
  void select(SelectItemModel item) {
    item.selected = true;
  }
  
  void deselect(SelectItemModel item) {
    item.selected = false;
  }
  
}