part of picklist;

@observable
class PicklistModel {
  ObservableList<Object> _items = new ObservableList();
  ObservableList<Object> pickedItems = new ObservableList();
  Object _selectedSourceItem;
  Object _selectedTargetItem;
  String addLabel = "Add";
  String addAllLabel = "Add All";
  String removeLabel = "Remove";
  String removeAllLabel = "Remove All";
  int height = 202;
  String sourceHeader;
  String targetHeader;
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
  
  SafeHtml get _safeSourceHeader => new SafeHtml.unsafe("<span>${sourceHeader}</span>");
  
  SafeHtml get _safeTargetHeader => new SafeHtml.unsafe("<span>${targetHeader}</span>");
}