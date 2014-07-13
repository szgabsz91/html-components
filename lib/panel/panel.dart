import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

@CustomTag('h-panel')
class PanelComponent extends PolymerElement {
  
  @published bool closable = false;
  @published bool toggleable = false;
  @published bool collapsed = false;
  @published String header = "";
  @published String content = "";
  @published String footer = null;
  
  int _contentHeight = 0;
  
  PanelComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    List<Element> elements = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is Element).toList(growable: false);
    Element headerElement = elements.firstWhere((Element element) => element.tagName == 'HEADER', orElse: () => null);
    Element footerElement = elements.firstWhere((Element element) => element.tagName == 'FOOTER', orElse: () => null);
    
    if (headerElement != null) {
      header = headerElement.innerHtml;
      headerElement.remove();
    }
    
    if (footerElement != null) {
      footer = footerElement.innerHtml;
      footerElement.remove();
    }
    
    elements = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is Element).toList(growable: false);
    if (elements.isNotEmpty) {
      content = elements.first.parent.innerHtml;
    }
    
    $['hidden'].remove();
    
    if (collapsed) {
      Timer.run(() {
        _refreshContentHeight();
        
        $['content'].style
          ..overflow = 'hidden'
          ..height = '0px'
          ..paddingTop = '0px'
          ..paddingBottom = '0px';
      });
    }
  }
  
  void open() {
    $['content'].style
      ..maxHeight = '${_contentHeight}px'
      ..paddingTop = '5px'
      ..paddingBottom = '5px';
    new Timer(const Duration(milliseconds: 500), () {
      collapsed = false;
      $['content'].style.overflow = 'auto';
      this.dispatchEvent(new CustomEvent('toggled', detail: 'VISIBLE'));
    });
  }
  
  void collapse() {
    if (_contentHeight == 0) {
      _refreshContentHeight();
    }
    
    $['content'].style.maxHeight = '${_contentHeight}px';
    
    new Timer(const Duration(milliseconds: 50), () {
      $['content'].style
        ..maxHeight = '0'
        ..paddingTop = '0'
        ..paddingBottom = '0'
        ..overflow = 'hidden';
      new Timer(const Duration(milliseconds: 500), () {
        collapsed = true;
        this.dispatchEvent(new CustomEvent('toggled', detail: 'HIDDEN'));
      });
    });
  }
  
  void onButtonMouseOver(MouseEvent event, var detail, Element target) {
    target.classes.add('hover');
  }
  
  void onButtonMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onClosed(MouseEvent event) {
    event.preventDefault();
    
    if (_contentHeight == 0) {
      _refreshContentHeight();
    }
    
    $['container'].style.maxHeight = '${_contentHeight}px';
    
    new Timer(const Duration(milliseconds: 50), () {
      $['container'].style
        ..opacity = '0'
        ..overflow = 'hidden';
      
      $['container'].style
        ..maxHeight = '0'
        ..padding = '0'
        ..margin = '0';
      new Timer(const Duration(milliseconds: 500), () {
        this.dispatchEvent(new Event('closed'));
        this.remove();
      });
    });
  }
  
  void onToggled(MouseEvent event) {
    event.preventDefault();
    
    if (collapsed) {
      open();
    }
    else {
      collapse();
    }
  }
  
  void _refreshContentHeight() {
    _contentHeight = $['content'].clientHeight;
  }
  
}