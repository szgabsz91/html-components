library gallery;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "package:animation/animation.dart" as animation;
import "../common/wrappers.dart";

part "gallery/model.dart";

class GalleryComponent extends WebComponent {
  GalleryModel model = new GalleryModel();
  
  static const int CAPTION_HEIGHT = 80;
  
  DivElement get _hiddenArea => this.query(".x-gallery_ui-helper-hidden");
  List<ImageElement> get _imageElements => _hiddenArea.queryAll("img");
  ImageElement get _currentImage => this.queryAll("img").elementAt(model.currentIndex);
  DivElement get _caption => this.query(".ui-gallery-caption");
  
  void inserted() {
    ImageElement firstImage = _imageElements.elementAt(0);
    model.imageSize.width = firstImage.width;
    model.imageSize.height = firstImage.height;
    
    _imageElements.forEach((ImageElement image) {
      model.images.add(new ImageModel(image.src, image.alt, image.title));
    });
    
    _hiddenArea.remove();
    
    Timer.run(start);
  }
  
  int get delay => model.delay;
  set delay(var delay) {
    if (delay is int) {
      model.delay = delay;
    }
    else if (delay is String) {
      model.delay = int.parse(delay);
    }
    else {
      throw new ArgumentError("The delay property must be of type int or String!");
    }
  }
  
  void showNext() {
    ImageElement previousImage = _currentImage;
    _setCurrentIndexTo(model.currentIndex + 1);
    ImageElement currentImage = _currentImage;
    
    previousImage.style.opacity = "0";
    currentImage.style.opacity = "1";
    
    Map<String, Object> hideAnimationProperties = {
      "height": 0
    };
    
    Map<String, Object> showAnimationProperties = {
      "height": CAPTION_HEIGHT
    };
    
    animation.animate(_caption, properties: hideAnimationProperties, duration: 250).onComplete.listen((_) {
      model.currentTitle = currentImage.title;
      model.currentAlt = currentImage.alt;
      animation.animate(_caption, properties: showAnimationProperties, duration: 250);
    });
    
    new Future.delayed(new Duration(milliseconds: model.delay), showNext);
  }
  
  void start() {
    ImageElement currentImage = _currentImage;
    model.currentTitle = currentImage.title;
    model.currentAlt = currentImage.alt;
    
    Map<String, Object> animationProperties = {
      "height": CAPTION_HEIGHT
    };
    
    currentImage.style.opacity = "1";
    animation.animate(_caption, properties: animationProperties, duration: 250);
    
    new Future.delayed(new Duration(milliseconds: model.delay), showNext);
  }
  
  // TODO Copy from lightbox (maybe mixin?)
  void _setCurrentIndexTo(int newIndex) {
    model.currentIndex = newIndex;
    
    if (model.currentIndex >= model.images.length) {
      model.currentIndex = 0;
    }
    
    if (model.currentIndex < 0) {
      model.currentIndex = model.images.length - 1;
    }
  }
}