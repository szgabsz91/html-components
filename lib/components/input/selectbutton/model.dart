part of selectbutton;

@observable
class SelectButtonModel {
  String _selection = "single";
  ObservableList<SelectItemComponent> _selectedItems = new ObservableList();
  
  String get selection => _selection;
  set selection(String selection) {
    if (["single", "multiple"].contains(selection)) {
      _selection = selection;
    }
    else {
      throw new ArgumentError("The selection property must be single or multiple!");
    }
  }
  
  ObservableList<SelectItemModel> get selectedItems {
    return toObservable(
      _selectedItems.map((SelectItemComponent component) => component.model)
                    .toList(growable: false)
    );
  }
}