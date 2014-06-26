import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart' as animation;

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
    
    // Chrome stable CSS fix
    $['content'].style.marginTop = '0';
  }
  
  void open() {
    Map<String, Object> animationProperties = {
      'height': _contentHeight,
      'padding-top': 5,
      'padding-bottom': 5
    };
    
    animation.animate($['content'], properties: animationProperties, duration: 500).onComplete.listen((_) {
      collapsed = false;
      $['content'].style.overflow = 'auto';
      this.dispatchEvent(new CustomEvent('toggled', detail: 'VISIBLE'));
    });
  }
  
  void collapse() {
    if (_contentHeight == 0) {
      _refreshContentHeight();
    }
    
    Map<String, Object> animationProperties = {
      'height': 0,
      'padding-top': 0,
      'padding-bottom': 0
    };
    
    $['content'].style.overflow = 'hidden';
    animation.animate($['content'], properties: animationProperties, duration: 500).onComplete.listen((_) {
      collapsed = true;
      this.dispatchEvent(new CustomEvent('toggled', detail: 'HIDDEN'));
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
    
    Map<String, Object> animationProperties = {
      'height': 0,
      'padding': 0,
      'margin': 0
    };
    
    $['container'].style.opacity = "0";
    this.style.overflow = "hidden";
    
    animation.animate($['container'], properties: animationProperties, duration: 500);
    animation.animate(this, properties: animationProperties, duration: 500).onComplete.listen((_) {
      this.dispatchEvent(new Event('closed'));
      this.remove();
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