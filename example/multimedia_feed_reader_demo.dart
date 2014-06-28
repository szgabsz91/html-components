import 'package:polymer/polymer.dart';
import 'package:html_components/html_components.dart';

@CustomTag('feed-reader-demo')
class FeedReaderDemo extends PolymerElement {
  
  FeedReaderDemo.created() : super.created();
  
  void onFeedReaderRefreshed() {
    GrowlComponent.postMessage('', 'Feed reader refreshed!');
  }
  
}