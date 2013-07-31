part of feedreader;

@observable
class FeedReaderModel {
  String url;
  int maxItems;
  bool autoRefresh;
  TemplateManager _templateManager;
  Feed feed;
  
  ObservableList<FeedItem> get visibleItems {
    if (feed == null) {
      return new ObservableList();
    }
    
    List<FeedItem> visibleItems;
    
    if (maxItems != null) {
      visibleItems = feed.items.take(maxItems).toList(growable: false);
    }
    else {
      visibleItems = feed.items;
    }
    
    return toObservable(visibleItems);
  }
}