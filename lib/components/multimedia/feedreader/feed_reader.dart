part of feedreader;

class FeedReader {
  Uri _url;
  
  FeedReader(String url) {
    _url = Uri.parse(url);
  }
  
  Future<Feed> read() {
    Completer completer = new Completer();
    
    HttpRequest.getString(_url.toString()).then((String response) {
      DomParser xmlParser = new DomParser();
      Document rssDocument = xmlParser.parseFromString(response, "text/xml");
      Feed feed = _createFeedObject(rssDocument);
      completer.complete(feed);
    }).catchError((Object error) => print("An error occured: $error"));
    
    return completer.future;
  }
  
  Feed _createFeedObject(Document rssDocument) {
    Feed feed = new Feed();
    
    rssDocument.documentElement.children.first.children.forEach((Element element) {
      switch (element.tagName) {
        case "title":
          feed.title = element.text;
          break;
        
        case "link":
          feed.link = element.text;
          break;
        
        case "description":
          feed.description = element.text;
          break;
        
        case "ttl":
          feed.ttl = int.parse(element.text);
          break;
        
        case "item":
          feed.items.add(_createFeedItemObject(element));
          break;
      }
    });
    
    return feed;
  }
  
  FeedItem _createFeedItemObject(Element itemElement) {
    FeedItem feedItem = new FeedItem();
    
    itemElement.children.forEach((Element element) {
      switch (element.tagName) {
        case "title":
          feedItem.title = element.text;
          break;
          
        case "link":
          feedItem.link = element.text;
          break;
          
        case "description":
          feedItem.description = element.text;
          break;
      }
    });
    
    return feedItem;
  }
}