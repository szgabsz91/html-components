library lightbox;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart';
import '../common/wrappers.dart';

part 'lightbox/model.dart';

class LightboxComponent extends WebComponent {
  LightboxModel model = new LightboxModel();
  
  DivElement get _lightbox => this.query(".x-lightbox_ui-lightbox");
  DivElement get _largeImageConainer => this.query(".x-lightbox_ui-lightbox-content");
  ImageElement get _largeImage => this.query(".x-lightbox_ui-lightbox img");
  List<AnchorElement> get _smallImageAnchors => this.queryAll(".thumbnails a");
  AnchorElement get _smallImageAnchor => _smallImageAnchors.elementAt(model.currentIndex);
  int get _imageCount => this.queryAll(".thumbnails a").length;
  DivElement get _hiddenContainer => this.query(".x-lightbox_container");
  ImageElement get _hiddenImage => _hiddenContainer.query("img");
  List<Element> get _navigationElements => this.queryAll(".x-lightbox_ui-lightbox-nav");
  DivElement get _caption => this.query(".x-lightbox_ui-lightbox-caption");
  DivElement get _overlay => this.query(".x-lightbox_ui-widget-overlay");
  
  void inserted() {
    _smallImageAnchors.forEach((AnchorElement anchor) {
      int index = anchor.parent.children.indexOf(anchor);
      
      anchor.onClick.listen((MouseEvent event) {
        event.preventDefault();
        show(index);
      });
    });
    
    model.documentSize
      ..width = document.body.clientWidth
      ..height = document.body.clientHeight;
    model.windowHeight = window.innerHeight;
  }
  
  void showNext() {
    _animateTo(model.currentIndex + 1);
  }
  
  void showPrevious() {
    _animateTo(model.currentIndex - 1);
  }
  
  void show(int index) {
    _setCurrentIndexTo(index);
    model.hidden = false;
    _refreshImage();
  }
  
  void hide() {
    _lightbox.style.opacity = "0";
    _overlay.style.opacity = "0";
    
    new Future.delayed(new Duration(milliseconds: 1000), () {
      model.hidden = true;
      
      _navigationElements.forEach((Element element) => element.style.opacity = "0");
      _largeImage.style.opacity = "0";
      _largeImageConainer.classes.add("x-lightbox_ui-lightbox-loading");
      _caption.style.opacity = "0";
      
      _caption.style.height = "0";
      _largeImage.remove();
      
      model.currentSize.width = 50;
      model.currentSize.height = 50;
      _largeImageConainer.style
        ..width = "50px"
        ..height = "50px";
      _lightbox.style
        ..width = "50px"
        ..height = "50px";
      
      _lightbox.style.opacity = "1";
      _overlay.style.opacity = ".30";
    });
  }
  
  void _onCloseClicked(MouseEvent event) {
    event.preventDefault();
    hide();
  }
  
  void _refreshSize() {
    model.currentSize.width = _hiddenImage.width;
    model.currentSize.height = _hiddenImage.height;
    
    var properties = {
      'width': _hiddenImage.width,
      'height': _hiddenImage.height,
      'left': (model.documentSize.width - model.currentSize.width) / 2,
      'top': (model.windowHeight - model.currentSize.height) / 2
    };
    
    model.currentLabel = _smallImageAnchor.title;
    _largeImageConainer.children.add(_hiddenImage);
    
    animate(_largeImageConainer, properties: {'width': model.currentSize.width, 'height': model.currentSize.height}, duration: 1000);
    animate(_lightbox, properties: properties, duration: 1000).onComplete.listen((_) {
      _largeImageConainer.classes.remove("x-lightbox_ui-lightbox-loading");
      _largeImage.style.opacity = "1";
      _navigationElements.forEach((Element element) => element.style.opacity = "1");
      _caption.style.opacity = "1";
      animate(_caption, properties: {'height': 31}, duration: 500);
    });
  }
  
  void _setCurrentIndexTo(int newIndex) {
    model.currentIndex = newIndex;
    
    if (model.currentIndex >= _imageCount) {
      model.currentIndex = 0;
    }
    
    if (model.currentIndex < 0) {
      model.currentIndex = _imageCount - 1;
    }
  }
  
  void _animateTo(int index) {
    _navigationElements.forEach((Element element) => element.style.opacity = "0");
    _largeImage.style.opacity = "0";
    _largeImageConainer.classes.add("x-lightbox_ui-lightbox-loading");
    _caption.style.opacity = "0";
    
    animate(_caption, properties: {'height': 0}, duration: 500).onComplete.listen((_) {
      _largeImage.remove();
      _setCurrentIndexTo(index);
      _refreshImage();
    });
  }
  
  void _refreshImage() {
    ImageElement image = new ImageElement(src: _smallImageAnchor.href);
    
    image.onLoad.listen((_) {
      _refreshSize();
    });
    
    _hiddenContainer.children.add(image);
  }
}