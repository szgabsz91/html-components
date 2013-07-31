library panel;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "package:animation/animation.dart" as animation;

part "panel/model.dart";

class PanelComponent extends WebComponent {
  PanelModel model = new PanelModel();
  int _contentHeight = 0;
  
  DivElement get _hiddenArea => this.query(".x-panel_ui-helper-hidden");
  Element get _header => _hiddenArea.query("header");
  Element get _footer => _hiddenArea.query("footer");
  DivElement get _panel => this.query(".x-panel_ui-panel");
  DivElement get _content => this.query(".x-panel_ui-panel-content");
  SpanElement get _toggleButton => this.query(".x-panel_ui-icon-minusthick") == null ? this.query(".x-panel_ui-icon-plusthick") : this.query(".x-panel_ui-icon-minusthick");
  bool get _isCollapsed => _content.style.overflow == "hidden";
  
  static const EventStreamProvider<Event> _CLOSED_EVENT = const EventStreamProvider<Event>("closed");
  Stream<Event> get onClosed => _CLOSED_EVENT.forTarget(this);
  static _dispatchClosedEvent(Element element) {
    element.dispatchEvent(new Event("closed"));
  }
  
  static const EventStreamProvider<CustomEvent> _TOGGLED_EVENT = const EventStreamProvider<CustomEvent>("toggled");
  Stream<CustomEvent> get onToggled => _TOGGLED_EVENT.forTarget(this);
  static _dispatchToggledEvent(Element element, String visibility) {
    element.dispatchEvent(new CustomEvent("toggled", detail: visibility));
  }
  
  void inserted() {
    if (_header != null) {
      model.header = _header.innerHtml;
      _header.remove();
    }
    
    if (_footer != null) {
      model.footer = _footer.innerHtml;
      _footer.remove();
    }
    
    model.content = _hiddenArea.innerHtml;
    _hiddenArea.remove();
  }
  
  bool get closable => model.closable;
  set closable(var closable) {
    if (closable is bool) {
      model.closable = closable;
    }
    else if (closable is String) {
      model.closable = closable == "true";
    }
    else {
      throw new ArgumentError("The closable property must be of type bool or String!");
    }
  }
  
  bool get toggleable => model.closable;
  set toggleable(var toggleable) {
    if (toggleable is bool) {
      model.toggleable = toggleable;
    }
    else if (toggleable is String) {
      model.toggleable = toggleable == "true";
    }
    else {
      throw new ArgumentError("The toggleable property must be of type bool or String!");
    }
  }
  
  void _onMouseOver(MouseEvent event) {
    AnchorElement target;
    
    Element eventTarget = event.target;
    if (eventTarget is SpanElement) {
      target = eventTarget.parent;
    }
    else {
      target = eventTarget;
    }
    
    target.classes.add("x-panel_ui-state-hover");
  }
  
  void _onMouseOut(MouseEvent event) {
    AnchorElement target;
    
    Element eventTarget = event.target;
    if (eventTarget is SpanElement) {
      target = eventTarget.parent;
    }
    else {
      target = eventTarget;
    }
    
    target.classes.remove("x-panel_ui-state-hover");
  }
  
  void _onClosed(MouseEvent event) {
    event.preventDefault();
    
    Map<String, Object> animationProperties = {
      "height": 0,
      "padding": 0,
      "margin": 0
    };
    
    _panel.style.opacity = "0";
    this.style.overflow = "hidden";
    
    animation.animate(this, properties: animationProperties, duration: 500).onComplete.listen((_) {
      this.remove();
      _dispatchClosedEvent(this);
    });
  }
  
  void _onToggled(MouseEvent event) {
    event.preventDefault();
    
    if (_isCollapsed) {
      Map<String, Object> animationProperties = {
        "height": _contentHeight,
        "padding-top": 5,
        "padding-bottom": 5
      };
      
      _toggleButton.classes
        ..remove("x-panel_ui-icon-plusthick")
        ..add("x-panel_ui-icon-minusthick");
      
      animation.animate(_content, properties: animationProperties, duration: 500).onComplete.listen((_) {
        _content.style.overflow = "auto";
        _dispatchToggledEvent(this, "VISIBLE");
      });
    }
    else {
      if (_contentHeight == 0) {
        _refreshContentHeight();
      }
      
      Map<String, Object> animationProperties = {
        "height": 0,
        "padding-top": 0,
        "padding-bottom": 0
      };
      
      _content.style.overflow = "hidden";
      _toggleButton.classes
        ..remove("x-panel_ui-icon-minusthick")
        ..add("x-panel_ui-icon-plusthick");
      
      animation.animate(_content, properties: animationProperties, duration: 500).onComplete.listen((_) {
        _dispatchToggledEvent(this, "HIDDEN");
      });
    }
  }
  
  void _refreshContentHeight() {
    _contentHeight = _content.clientHeight;
  }
}