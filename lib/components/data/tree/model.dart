part of tree;

@observable
class TreeModel {
  TreeDataFetcher _fetcher;
  bool animate = false;
  String _selection = "single";
  List<Object> _selectedItems = new List();
  bool _selectMultiple = false;
  Map<String, TreeTemplateManager> __templateManagers = <String, TreeTemplateManager>{};
  Map<String, TreeNodeModel> __treeNodeModels = <String, TreeNodeModel>{};
  
  String get selection => _selection;
  set selection(String selection) {
    if (["single", "multiple"].contains(selection)) {
      _selection = selection;
    }
    else {
      throw new ArgumentError("The selection property must be single or multiple!");
    }
  }
  
  List<Object> get selectedItems => _selectedItems;
  
  Object get selectedItem {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    return selectedItems.first;
  }
  set selectedItem(Object selectedItem) {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    selectedItems.clear();
    selectedItems.add(selectedItem);
  }
  
  Map<String, TreeTemplateManager> get _templateManagers => __templateManagers;
  
  Map<String, TreeNodeModel> get _treeNodeModels => __treeNodeModels;
}