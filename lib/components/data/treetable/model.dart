part of treetable;

@observable
class TreetableModel {
  ObservableList<ColumnModel> columns = new ObservableList();
  ObservableList<TemplateManager> columnTemplateManagers = new ObservableList();
  String header;
  String footer;
  String _selection = "none";
  bool _multipleMode = false;
  TreetableDataFetcher _dataFetcher;
  ObservableList<Object> selectedNodes = new ObservableList();
  
  SafeHtml get _safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
  
  bool get showColumnHeader => columns.any((ColumnModel column) => column.header != null);
  
  SafeHtml get _safeFooter => new SafeHtml.unsafe("<span>${footer}</span>");
  
  bool get showColumnFooter => columns.any((ColumnModel column) => column.footer != null);
  
  String get selection => _selection;
  set selection(String selection) {
    if (["none", "single", "multiple"].contains(selection)) {
      _selection = selection;
    }
    else {
      throw new ArgumentError("The selection property must be non, single or multiple!");
    }
  }
  
  Object get selectedNode {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    return selectedNodes.first;
  }
  set selectedNode(Object selectedItem) {
    if (selection != "single") {
      throw new UnsupportedError("The selectedItem property can be used only when selection is single!");
    }
    
    selectedNodes.clear();
    selectedNodes.add(selectedItem);
  }
}