import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart' as animation;

@CustomTag('h-lightbox')
class LightboxComponent extends PolymerElement {
  
  int currentIndex = -1;
  @observable int documentWidth = 0;
  @observable int documentHeight = 0;
  @observable int windowHeight = 0;
  @observable int currentWidth = 50;
  @observable int currentHeight = 50;
  @observable bool hidden = true;
  @observable bool loading = true;
  @observable String currentLabel = '';
  
  int get _imageCount => $['thumbnails'].querySelector('content').getDistributedNodes().length;
  AnchorElement get _smallImageAnchor => $['thumbnails'].querySelector('content').getDistributedNodes()[currentIndex];
  
  LightboxComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    $['thumbnails'].querySelector('content').getDistributedNodes().where((Node node) => node is AnchorElement).forEach((AnchorElement anchor) {
      anchor.style.textDecoration = 'none';
      
      int index = anchor.parent.children.indexOf(anchor);
      
      anchor.onClick.listen((MouseEvent event) {
        event.preventDefault();
        showImage(index);
      });
    });
    
    documentWidth = document.body.clientWidth;
    documentHeight = document.body.clientHeight;
    windowHeight = window.innerHeight;
  }
  
  void onPreviousButtonClicked() {
    _animateTo(currentIndex - 1);
  }
  
  void onNextButtonClicked() {
    _animateTo(currentIndex + 1);
  }
  
  void showImage(int index) {
    _setCurrentIndexTo(index);
    hidden = false;
    _refreshImage();
  }
  
  void hide() {
    $['container'].style.opacity = '0';
    $['overlay'].style.opacity = '0';
    
    new Future.delayed(new Duration(milliseconds: 1000), () {
      hidden = true;
      
      $['previous-button'].style.opacity = '0';
      $['next-button'].style.opacity = '0';
      $['image-placeholder'].querySelector('img').style.opacity = '0';
      loading = true;
      $['caption'].style.opacity = '0';
      
      $['caption'].style.height = "0";
      $['image-placeholder'].querySelector('img').remove();
      
      currentWidth = 50;
      currentHeight = 50;
      $['container'].style
        ..width = '50px'
        ..height = '50px';
      
      $['overlay'].style.opacity = null;
    });
  }
  
  void onCloseThickClicked(MouseEvent event) {
    event.preventDefault();
    hide();
  }
  
  void _refreshSize() {
    ImageElement hiddenImage = $['image-loader'].querySelector('img');
    
    currentWidth = hiddenImage.width;
    currentHeight = hiddenImage.height;
    
    Map<String, int> animationProperties = {
      'width': hiddenImage.width,
      'height': hiddenImage.height,
      'left': (documentWidth - currentWidth) / 2,
      'top': (windowHeight - currentHeight) / 2
    };
    
    currentLabel = _smallImageAnchor.title;
    $['image-placeholder'].children.add(hiddenImage);
    
    animation.animate($['image-placeholder'], properties: {'width': currentWidth, 'height': currentHeight}, duration: 1000);
    animation.animate($['container'], properties: animationProperties, duration: 1000).onComplete.listen((_) {
      loading = false;
      $['image-placeholder'].querySelector('img').style.opacity = '1';
      $['previous-button'].style.opacity = '1';
      $['next-button'].style.opacity = '1';
      $['caption'].style.opacity = "1";
      animation.animate($['caption'], properties: {'height': 31}, duration: 500);
    });
  }
  
  void _setCurrentIndexTo(int newIndex) {
    currentIndex = newIndex;
    
    if (currentIndex >= _imageCount) {
      currentIndex = 0;
    }
    
    if (currentIndex < 0) {
      currentIndex = _imageCount - 1;
    }
  }
  
  void _animateTo(int index) {
    $['previous-button'].style.opacity = '0';
    $['next-button'].style.opacity = '0';
    $['image-placeholder'].querySelector('img').style.opacity = '0';
    loading = true;
    $['caption'].style.opacity = "0";
    
    animation.animate($['caption'], properties: {'height': 0}, duration: 500).onComplete.listen((_) {
      $['image-placeholder'].querySelector('img').remove();
      _setCurrentIndexTo(index);
      _refreshImage();
    });
  }
  
  void _refreshImage() {
    ImageElement image = new ImageElement(src: _smallImageAnchor.href);
    
    image.onLoad.listen((_) {
      _refreshSize();
    });
    
    $['image-loader'].children.add(image);
  }
  
}