part of selectcheckboxmenu;

@observable
class SelectCheckboxMenuModel {
  String label;
  String queryExpression = "";
  ObservableList<SelectItemModel> items = new ObservableList();
  
  List<SelectItemModel> get _visibleItems {
    return items.where((SelectItemModel item) => item.label.toLowerCase().startsWith(queryExpression.toLowerCase()))
                .toList(growable: false);
  }
  
  List<SelectItemModel> get selectedItems {
    return items.where((SelectItemModel item) => item.selected)
                .toList(growable: false);
  }
}