part of selectlistbox;

@observable
class SelectListboxModel {
  ObservableList<Object> _items = new ObservableList();
  ObservableList<Object> selectedItems = new ObservableList();
  String _selection = "single";
  int width = 200;
  int height = 200;
  bool _selectMultiple = false;
  TemplateManager _templateManager;
  
  ObservableList<Object> get items => _items;
  set items(List<Object> items) {
    if (items is ObservableList) {
      _items = items;
    }
    else {
      _items = toObservable(items);
    }
  }
  
  Object get selectedItem {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    if (selectedItems.isNotEmpty) {
      return selectedItems.first;
    }
    
    return null;
  }
  set selectedItem(Object selectedItem) {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    selectedItems.clear();
    
    if (selectedItem != null) {
      selectedItems.add(selectedItem);
    }
  }
  
  String get selection => _selection;
  set selection(String selection) {
    if (["single", "multiple"].contains(selection)) {
      _selection = selection;
    }
    else {
      throw new ArgumentError("The selection property must be single or multiple!");
    }
  }
}