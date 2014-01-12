import 'package:polymer/polymer.dart';

class FeedItem extends Object with Observable {
  @observable String title;
  @observable String link;
  @observable String description;
  
  String toString() => 'FeedItem[title=$title, link=$link, description=$description]';
}