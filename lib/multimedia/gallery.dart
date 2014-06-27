import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart' as animation;
import '../common/image_model.dart';

export '../common/image_model.dart';

@CustomTag('h-gallery')
class GalleryComponent extends PolymerElement {
  
  @published int delay = 3000;
  
  @observable ObservableList<ImageModel> images = toObservable([]);
  @observable int imageWidth = 0;
  @observable int imageHeight = 0;
  @observable int currentIndex = 0;
  @observable String currentTitle= '';
  @observable String currentAlt = '';
  
  static const int CAPTION_HEIGHT = 80;
  
  GalleryComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    new Timer(const Duration(milliseconds: 500), () {
      List<ImageElement> imageElements = $['hidden'].querySelector('content').getDistributedNodes();
      ImageElement firstImage = imageElements[0];
      
      imageWidth = firstImage.width;
      imageHeight = firstImage.height;
      
      imageElements.forEach((ImageElement image) {
        images.add(new ImageModel(image.src, image.alt, image.title, 0.0));
      });
      
      $['hidden'].remove();
      
      start();
    });
  }
  
  void showNext() {
    ImageModel previousImage = images[currentIndex];
    _setCurrentIndexTo(currentIndex + 1);
    ImageModel currentImage = images[currentIndex];
    
    previousImage.opacity = 0.0;
    currentImage.opacity = 1.0;
    
    Map<String, Object> hideAnimationProperties = {
      'height': 0
    };
    
    Map<String, Object> showAnimationProperties = {
      'height': CAPTION_HEIGHT
    };
    
    animation.animate($['caption'], properties: hideAnimationProperties, duration: 250).onComplete.listen((_) {
      currentTitle = currentImage.title;
      currentAlt = currentImage.alt;
      animation.animate($['caption'], properties: showAnimationProperties, duration: 250);
    });
    
    new Future.delayed(new Duration(milliseconds: delay), showNext);
  }
  
  void start() {
    ImageModel currentImage = images[currentIndex];
    currentTitle = currentImage.title;
    currentAlt = currentImage.alt;
    
    images[currentIndex].opacity = 1.0;
    
    Map<String, Object> animationProperties = {
      'height': CAPTION_HEIGHT
    };
    
    animation.animate($['caption'], properties: animationProperties, duration: 250);
    
    new Future.delayed(new Duration(milliseconds: delay), showNext);
  }
  
  void _setCurrentIndexTo(int newIndex) {
    currentIndex = newIndex;
    
    if (currentIndex >= images.length) {
      currentIndex = 0;
    }
    
    if (currentIndex < 0) {
      currentIndex = images.length - 1;
    }
  }
  
}