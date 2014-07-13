import 'package:polymer/polymer.dart';
import '../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show FeedReaderComponent, GrowlComponent;

@CustomTag('feed-reader-demo')
class FeedReaderDemo extends ShowcaseItem {
  
  @observable String url = 'http://gdata.youtube.com/feeds/base/users/GoogleDevelopers/uploads?alt=rss&v=2';
  
  FeedReaderDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/multimedia/feed-reader.html', 'demo/multimedia/feed-reader.dart']);
  }
  
  void onFeedReaderRefreshed(Event event, var detail, FeedReaderComponent target) {
    GrowlComponent.postMessage('', 'Feed reader refreshed!');
  }
  
}