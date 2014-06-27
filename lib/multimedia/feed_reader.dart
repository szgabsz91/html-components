import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'feed_reader/feed_item.dart';
import 'feed_reader/feed.dart';
import 'feed_reader/reader.dart';

export 'feed_reader/feed_item.dart';
export 'feed_reader/feed.dart';
export 'feed_reader/reader.dart';

@CustomTag('h-feed-reader')
class FeedReaderComponent extends PolymerElement {
  
  @published String url;
  @published int maxItems;
  @published bool autoRefresh;
  
  @observable Feed feed;
  @observable List<FeedItem> visibleItems = toObservable([]);
  
  String itemTemplate;
  FeedReader reader;
  
  FeedReaderComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    itemTemplate = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is Element).first.parent.innerHtml;
    
    reader = new FeedReader(url);
    
    onRefreshClicked(firstLoad: true);
  }
  
  void onRefreshClicked({bool firstLoad: false}) {
    reader.read().then((Feed feed) {
      this.feed = feed;
      
      this.visibleItems
        ..clear()
        ..addAll(maxItems != null ? feed.items.take(maxItems) : feed.items);
      
      if (autoRefresh) {
        new Future.delayed(new Duration(minutes: feed.ttl), onRefreshClicked);
      }
      
      if (!firstLoad) {
        this.dispatchEvent(new Event('refreshed'));
      }
    });
  }
  
}