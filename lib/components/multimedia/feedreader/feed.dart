part of feedreader;

class Feed {
  String title;
  String link;
  String description;
  int ttl;
  List<FeedItem> items = <FeedItem>[];
  
  String toString() => "Feed[title=$title, link=$link, description=$description, ttl=$ttl]";
}