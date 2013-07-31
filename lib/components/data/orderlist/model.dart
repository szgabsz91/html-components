part of orderlist;

@observable
class OrderlistModel {
  ObservableList<Object> _items = new ObservableList();
  Object _selectedItem;
  int width = 241;
  int height = 233;
  String moveUpLabel = "Move Up";
  String moveTopLabel = "Move Top";
  String moveDownLabel = "Move Down";
  String moveBottomLabel = "Move Bottom";
  String header;
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
  
  SafeHtml get _safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
}