library carousel;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "dart:json" as json;
import "package:animation/animation.dart" as animation;
import "../panel/tab.dart";
import "../common/templates.dart";
import "../common/converters.dart" as converters;
import "../common/generators.dart" as generators;
import "../common/wrappers.dart";

part "carousel/template_manager.dart";
part "carousel/data.dart";
part "carousel/model.dart";

class CarouselComponent extends WebComponent {
  CarouselModel model = new CarouselModel();
  
  DivElement get _hiddenArea => this.query(".x-carousel_ui-helper-hidden");
  DivElement get _header => this.query(".x-carousel_ui-carousel-header");
  DivElement get _footer => this.query(".x-carousel_ui-carousel-footer");
  UListElement get _listContainer => this.query("ul");
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<Event> get onSelected => _SELECTED_EVENT.forTarget(this);
  static void _dispatchSelectedEvent(Element element, Object item) {
    element.dispatchEvent(new CustomEvent("selected", detail: item.toString()));
  }
  
  void inserted() {
    DivElement hiddenArea = _hiddenArea;
    
    Element header = hiddenArea.query("header");
    if (header != null) {
      model.header = header.innerHtml;
      header.remove();
    }
    
    Element footer = hiddenArea.query("footer");
    if (footer != null) {
      model.footer = footer.innerHtml;
      footer.remove();
    }
    
    hiddenArea.classes.remove("x-carousel_ui-helper-hidden");
    
    List<DivElement> tabs = hiddenArea.queryAll('div[is="x-tab"]');
    if (tabs.isNotEmpty) {
      model._itemWidth = tabs.first.clientWidth;
      model._itemHeight = tabs.first.clientHeight;
      String classes = tabs.first.classes.join(" ");
      
      model._templateManager = new CarouselTemplateManager('<div class="${classes}">\${content}</div>');
      
      tabs.forEach((DivElement tabElement) {
        TabComponent tabComponent = tabElement.xtag;
        model.items.add(tabComponent.model);
        tabElement.remove();
      });
    }
    
    Element template = hiddenArea.query("template");
    if (template != null && template.content.children.isNotEmpty) {
      Element content = template.content.children.first;
      hiddenArea.children.add(content);
      
      model._itemWidth = content.clientWidth;
      model._itemHeight = content.clientHeight;
      
      model._templateManager = new CarouselTemplateManager(hiddenArea.innerHtml);
      
      template.remove();
      content.remove();
    }
    
    List<ImageElement> images = hiddenArea.queryAll("img");
    if (images.isNotEmpty) {
      model._itemWidth = images.first.width;
      model._itemHeight = images.first.height;
      
      images.forEach((ImageElement image) {
        model.items.add(new ImageModel(image.src, image.alt, image.title));
        
        model._templateManager = new CarouselTemplateManager(r'<div><img src="${src}" alt="${alt}" title="${title}"/></div>');
        
        image.remove();
      });
    }
    
    hiddenArea.classes.add("x-carousel_ui-helper-hidden");
    hiddenArea.remove();
    
    if (model.autoplayInterval > 0) {
      new Timer.periodic(new Duration(milliseconds: model.autoplayInterval), (_) {
        navigateToNextPage();
      });
    }
  }
  
  set data(var data) {
    if (data is List) {
      new CarouselClientDataFetcher(data)
        .fetchData()
        .then(_refreshItems);
    }
    else if (data is String) {
      Uri serviceURL = Uri.parse(data);
      
      new CarouselServerDataFetcher(serviceURL)
        .fetchData()
        .then(_refreshItems)
        .catchError((Object error) => print("An error occured: $error"));
    }
    else {
      throw new ArgumentError("The data property must be of type List or String!");
    }
  }
  
  int get visibleitems => model.visibleItems;
  set visibleitems(var visibleitems) {
    if (visibleitems is int) {
      model.visibleItems = visibleitems;
    }
    else if (visibleitems is String) {
      model.visibleItems = int.parse(visibleitems);
    }
    else {
      throw new ArgumentError("The visibleitems property must be of type int or String!");
    }
  }
  
  int get pagelinks => model.pageLinks;
  set pagelinks(var pagelinks) {
    if (pagelinks is int) {
      model.pageLinks = pagelinks;
    }
    else if (pagelinks is String) {
      model.pageLinks = int.parse(pagelinks);
    }
    else {
      throw new ArgumentError("The pagelinks property must be of type int or String!");
    }
  }
  
  bool get circular => model.circular;
  set circular(var circular) {
    if (circular is bool) {
      model.circular = circular;
    }
    else if (circular is String) {
      model.circular = circular == "true";
    }
    else {
      throw new ArgumentError("The circular property must be of type bool or String!");
    }
  }
  
  int get autoplayinterval => model.autoplayInterval;
  set autoplayinterval(var autoplayinterval) {
    if (autoplayinterval is int) {
      model.autoplayInterval = autoplayinterval;
    }
    else if (autoplayinterval is String) {
      model.autoplayInterval = int.parse(autoplayinterval);
    }
    else {
      throw new ArgumentError("The autoplayinterval property must be of type int or String!");
    }
  }
  
  String get _currentPage => model.currentPage.toString();
  set _currentPage(String currentPage) {
    int newPage = int.parse(currentPage);
    navigateToPage(newPage);
  }
  
  void _refreshItems(List<Object> items) {
    model.items = items;
  }
  
  void navigateToPage(int page) {
    model.currentPage = page;
    
    int newLeft = -(page - 1) * model.visibleItems * (model._itemWidth + 4);
    
    Map<String, Object> animationProperties = {
      "left": newLeft
    };
    
    animation.animate(_listContainer, properties: animationProperties, duration: 500);
  }
  
  void navigateToPreviousPage() {
    if (model.currentPage == 1 && !model.circular) {
      return;
    }
    
    int newPage = model.currentPage - 1;
    
    if (newPage <= 0) {
      newPage = model.totalPages;
    }
    
    navigateToPage(newPage);
  }
  
  void navigateToNextPage() {
    if (model.currentPage == model.totalPages && !model.circular) {
      return;
    }
    
    int newPage = model.currentPage + 1;
    
    if (newPage > model.totalPages) {
      newPage = 1;
    }
    
    navigateToPage(newPage);
  }
  
  void _onPageLinkClicked(MouseEvent event, int page) {
    event.preventDefault();
    
    AnchorElement target = event.target;
    
    if (target.classes.contains("x-carousel_ui-state-disabled")) {
      return;
    }
    
    navigateToPage(page);
  }
  
  void _onSelectFocused(Event event) {
    SelectElement target = event.target;
    target.classes.add("x-carousel_ui-state-hover");
  }
  
  void _onSelectBlurred(Event event) {
    SelectElement target = event.target;
    
    if (event.type != "blur" && target.attributes.containsKey("data-focused")) {
      return;
    }
    
    target.classes.remove("x-carousel_ui-state-hover");
    target.attributes.remove("data-focused");
  }
  
  void _onSelectClicked(MouseEvent event) {
    SelectElement target = event.target;
    
    if (target.attributes.containsKey("data-focused")) {
      target.attributes.remove("data-focused");
    }
    else {
      target.attributes["data-focused"] = "true";
    }
  }
  
  void _onItemClicked(MouseEvent event, Object item) {
    Element target = event.target;
    
    if (target is SpanElement) {
      target = target.parent;
    }
    
    if (target is AnchorElement && target.classes.contains("x-carousel_ui-commandlink")) {
      event.preventDefault();
      
      if (item is Map) {
        _dispatchSelectedEvent(this, converters.mapToString(item));
      }
      else {
        _dispatchSelectedEvent(this, item);
      }
    }
  }
  
  SafeHtml _getHeaderContent() {
    if (model.header != null) {
      return model._safeHeader;
    }
    else if (model.visibleItems == 1) {
      if (model.items.any((Object item) => item is TabModel)) {
        TabModel currentTab = model.items[model.currentPage - 1];
        String currentLabel = currentTab.label;
        return new SafeHtml.unsafe("<span>${currentLabel}</span>");
      }
      else if (model.items.any((Object item) => item is ImageModel)) {
        ImageModel currentImage = model.items[model.currentPage - 1];
        String currentTitle = currentImage.title;
        String currentAlt = currentImage.alt;
        
        if (currentTitle != "") {
          return new SafeHtml.unsafe("<span>${currentTitle}</span>");
        }
        else {
          return new SafeHtml.unsafe("<span>${currentAlt}</span>");
        }
      }
    }
    else {
      return new SafeHtml.unsafe("<span></span>");
    }
  }
  
  SafeHtml _getItemAsHtml(Object item) {
    String htmlString = model._templateManager.getSubstitutedString(item);
    return new SafeHtml.unsafe("<span>${htmlString}</span>");
  }
}