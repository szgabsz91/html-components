library feedreader;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "../common/templates.dart";

part "feedreader/feed_item.dart";
part "feedreader/feed.dart";
part "feedreader/feed_reader.dart";
part "feedreader/model.dart";

class FeedReaderComponent extends WebComponent {
  FeedReaderModel model = new FeedReaderModel();
  FeedReader _feedReader;
  
  DivElement get _container => this.query(".feed-item-container");
  DivElement get _hiddenArea => this.query(".x-feedreader_ui-helper-hidden");
  TemplateElement get _templateElement => _hiddenArea.query("template:first-child");
  
  static const EventStreamProvider<Event> _REFRESHED_EVENT = const EventStreamProvider<Event>("refreshed");
  Stream<Event> get onRefreshed => _REFRESHED_EVENT.forTarget(this);
  static void _dispatchRefreshedEvent(Element element) {
    element.dispatchEvent(new Event("refreshed"));
  }
  
  void inserted() {
    if (_templateElement != null) {
      model._templateManager = new TemplateManager(_templateElement.content.innerHtml);
    }
    _hiddenArea.remove();
    
    _feedReader = new FeedReader(model.url);
    
    refresh();
  }
  
  String get url => model.url;
  set url(String url) => model.url = url;
  
  int get maxitems => model.maxItems;
  set maxitems(var maxitems) {
    if (maxitems is int) {
      model.maxItems = maxitems;
    }
    else if (maxitems is String) {
      model.maxItems = int.parse(maxitems);
    }
    else {
      throw new ArgumentError("The maxitems property must be of type int or String!");
    }
  }
  
  bool get autorefresh => model.autoRefresh;
  set autorefresh(var autorefresh) {
    if (autorefresh is bool) {
      model.autoRefresh = autorefresh;
    }
    else if (autorefresh is String) {
      model.autoRefresh = autorefresh == "true";
    }
    else {
      throw new ArgumentError("The autorefresh property must be of type bool or String!");
    }
  }
  
  void refresh() {
    _feedReader.read().then((Feed feed) {
      model.feed = feed;
      
      if (model.autoRefresh) {
        new Future.delayed(new Duration(minutes: model.feed.ttl), refresh);
      }
      
      _dispatchRefreshedEvent(this);
    }).catchError((Object error) => print("An error occured: $error"));
  }
  
  SafeHtml _getItemAsHtml(FeedItem item) {
    String htmlString = model._templateManager.getSubstitutedString(item);
    return new SafeHtml.unsafe("<div>${htmlString}</div>");
  }
}