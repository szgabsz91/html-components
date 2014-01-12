import 'package:polymer/polymer.dart';
import 'feed_item.dart';

class Feed extends Object with Observable {
  @observable String title;
  @observable String link;
  @observable String description;
  @observable int ttl;
  @observable List<FeedItem> items = toObservable([]);
  
  String toString() => 'Feed[title=$title, link=$link, description=$description, ttl=$ttl]';
}