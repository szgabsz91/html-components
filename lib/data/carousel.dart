import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import '../panel/tab.dart';
import 'carousel/data.dart';
import '../common/image_model.dart';

@CustomTag('h-carousel')
class CarouselComponent extends PolymerElement {
  
  @published int visibleItems = 1;
  @published int pageLinks = 0;
  @published bool circular = false;
  @published int autoplayInterval = 0;
  @published List data;
  @published String source;
  
  @observable int currentPage = 1;
  @observable String header;
  @observable String footer;
  @observable String template;
  @observable int itemWidth = 0;
  @observable int itemHeight = 0;
  
  // calculated fields
  @observable int totalPages = 0;
  @observable List<int> pageIndices = toObservable([]);
  
  @observable Map<String, String> CUSTOM_TEMPLATES = toObservable({
    r'${carousel:selectButton}':
      r'''
        <a href="#" title="View Detail" class="select-button">
          <span></span>
        </a>
      ''',
    r'${carousel:totalCount}':
      '0'
  });
  
  CarouselComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    Timer.run(() {
      List<Element> children = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is Element).toList(growable: false);
      
      Element headerElement = children.firstWhere((Element element) => element.tagName == 'HEADER', orElse: () => null);
      if (headerElement != null) {
        header = headerElement.innerHtml;
        headerElement.remove();
      }
      
      Element footerElement = children.firstWhere((Element element) => element.tagName == 'FOOTER', orElse: () => null);
      if (footerElement != null) {
        footer = footerElement.innerHtml;
        footerElement.remove();
      }
      
      $['hidden'].classes.remove('hidden');
      
      List<TabComponent> tabs = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is TabComponent).toList(growable: false);
      
      if (tabs.isNotEmpty) {
        itemWidth = tabs.first.clientWidth;
        itemHeight = tabs.first.clientHeight;
        String style = tabs.first.attributes['style'];
        
        template = '<div style="${style}">\${content}</div>';
        data = toObservable([]);
        
        tabs.forEach((TabComponent tab) {
          data.add(tab.model);
          tab.remove();
        });
      }
      
      List<ImageElement> images = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is ImageElement).toList(growable: false);
      
      if (images.isNotEmpty) {
        itemWidth = images.first.width;
        itemHeight = images.first.height;
        
        data = toObservable([]);
        
        images.forEach((ImageElement image) {
          data.add(new ImageModel(image.src, image.alt, image.title));
          
          template = r'<div><img src="${src}" alt="${alt}" title="${title}"/></div>';
          
          image.remove();
        });
      }
      
      children = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is Element).toList(growable: false);
      
      if (children.isNotEmpty) {
        Element child = children.first;
        
        $['hidden'].children.add(child);
        itemWidth = child.clientWidth;
        itemHeight = child.clientHeight;
        
        template = $['hidden'].innerHtml;
      }
      
      $['hidden']
        ..classes.add('hidden')
        ..remove();
      
      if (source != null) {
        new CarouselServerDataFetcher(Uri.parse(source)).fetchData().then((List data) {
          this.data = data;
        });
      }
      
      navigateToPage(1);
      
      if (autoplayInterval > 0) {
        new Timer.periodic(new Duration(milliseconds: autoplayInterval), (_) {
          onNextIconClicked();
        });
      }
    });
  }
  
  void dataChanged() {
    _refreshCalculatedFields();
  }
  
  void visibleItemsChanged() {
    _refreshCalculatedFields();
  }
  
  void _refreshCalculatedFields() {
    if (data == null) {
      return;
    }
    
    totalPages = (data.length / visibleItems).ceil();
    if (totalPages == 0) {
      totalPages = 1;
    }
    
    pageIndices = toObservable(new Iterable.generate(totalPages, (int i) => i + 1).toList(growable: false));
    
    CUSTOM_TEMPLATES = toObservable({
      r'${carousel:selectButton}':
        r'''
          <span title="View Detail" class="select-button">
            <span></span>
          </span>
        ''',
      r'${carousel:totalCount}':
        '${data.length}'
    });
  }
  
  void onPreviousIconClicked() {
    if (currentPage == 1 && !circular) {
      return;
    }
    
    int newPage = currentPage - 1;
    
    if (newPage <= 0) {
      newPage = totalPages;
    }
    
    navigateToPage(newPage);
  }
  
  void onNextIconClicked() {
    if (currentPage == totalPages && !circular) {
      return;
    }
    
    int newPage = currentPage + 1;
    
    if (newPage > totalPages) {
      newPage = 1;
    }
    
    navigateToPage(newPage);
  }
  
  void onPageLinkClicked(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    int newPage = target.parent.children.indexOf(target);
    
    navigateToPage(newPage);
  }
  
  void onPageSelected(Event event, var detail, SelectElement target) {
    navigateToPage(target.selectedIndex + 1);
  }
  
  void navigateToPage(int page) {
    currentPage = page;
    
    int newLeft = -(page - 1) * visibleItems * (itemWidth + 4);
    
    $['item-list'].style.left = '${newLeft}px';
    
    if (data != null) {
      if (data.any((Object item) => item is TabModel)) {
        TabModel currentTab = data[currentPage - 1];
        String currentHeader = currentTab.header;
        header = currentHeader;
      }
      else if (data.any((Object item) => item is ImageModel)) {
        ImageModel currentImage = data[currentPage - 1];
        String currentTitle = currentImage.title;
        String currentAlt = currentImage.alt;
        
        if (currentTitle != '') {
          header = currentTitle;
        }
        else {
          header = currentAlt;
        }
      }
    }
  }
  
  void onItemClicked(MouseEvent event, var detail, Element target) {
    int selectedIndex = target.parent.children.indexOf(target) - 1;
    
    this.dispatchEvent(new CustomEvent('selected', detail: data[selectedIndex]));
  }
  
}