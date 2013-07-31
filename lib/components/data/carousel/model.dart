part of carousel;

@observable
class CarouselModel {
  int visibleItems = 1;
  int pageLinks = 0;
  bool circular = false;
  int autoplayInterval = 0;
  ObservableList<Object> _items = new ObservableList();
  int currentPage = 1;
  String header;
  String footer;
  int _itemWidth = 0;
  int _itemHeight = 0;
  CarouselTemplateManager _templateManager;
  
  ObservableList<Object> get items => _items;
  set items(List<Object> items) {
    if (items is ObservableList) {
      _items = items;
    }
    else {
      _items = toObservable(items);
    }
  }
  
  int get totalCount => items.length;
  
  int get totalPages {
    int result = (totalCount / visibleItems).ceil();
    
    if (result == 0) {
      return 1;
    }
    
    return result;
  }
  
  SafeHtml get _safeHeader => new SafeHtml.unsafe("<span>${header}</span>");
  
  String get _replacedFooter => footer.replaceAll(r"${carousel:totalCount}", totalCount.toString());
  SafeHtml get _safeFooter => new SafeHtml.unsafe("<span>${_replacedFooter}</span>");
}