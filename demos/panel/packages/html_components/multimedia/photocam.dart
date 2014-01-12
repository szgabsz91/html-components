import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

@CustomTag('h-photocam')
class PhotocamComponent extends PolymerElement {
  
  @published int width = 320;
  @published int height = 240;
  @published bool audio = false;
  @published String effect = '';
  
  @observable bool started = false;
  
  MediaStream _stream;
  
  PhotocamComponent.created() : super.created();
  
  void start() {
    window.navigator.getUserMedia(audio: audio, video: true).then((MediaStream stream) {
      _stream = stream;
      $['video'].src = Url.createObjectUrl(stream);
      
      new Timer(const Duration(milliseconds: 100), () {
        $['canvas']
          ..width = $['video'].videoWidth
          ..height = $['video'].videoHeight;
        $['image']
          ..width = $['video'].videoWidth
          ..height = $['video'].videoHeight;
      });
      
      started = true;
    });
  }
  
  void stop() {
    if (_stream == null) {
      return;
    }
    
    $['video'].pause();
    _stream.stop();
    _stream = null;
    
    started = false;
  }
  
  void snapshot() {
    if (_stream == null) {
      return;
    }
    
    $['canvas'].context2D.drawImage($['video'], 0, 0);
    $['image'].src = $['canvas'].toDataUrl('image/webp');
  }
  
  void restart() {
    stop();
    start();
  }
  
  
  void onButtonMouseOver(MouseEvent event, var detail, Element target) {
    if (target.classes.contains('disabled')) {
      return;
    }
    
    target.classes.add('hover');
  }
  
  void onButtonMouseOut(MouseEvent event, var detail, Element target) {
    target.classes.remove('hover');
  }
  
  void onStartButtonClicked(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    if (started) {
      return;
    }
    
    start();
  }
  
  void onStopButtonClicked(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    if (!started) {
      return;
    }
    
    stop();
    
    target.classes.remove('hover');
  }
  
  void onSnapshotButtonClicked(MouseEvent event, var detail, Element target) {
    event.preventDefault();
    
    if (!started) {
      return;
    }
    
    snapshot();
  }
  
}