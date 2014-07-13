import 'package:barback/barback.dart';
import 'dart:io';
import 'dart:async';

class ShowcaseTransformer extends Transformer {
  
  ShowcaseTransformer.asPlugin();
  
  String get allowedExtensions => '.dart';
  
  Future<bool> isPrimary(AssetId id) {
    for (var extension in allowedExtensions.split(' ')) {
      if (!id.path.endsWith(extension)) {
        return new Future.value(false);
      }
    }
    
    return new Future.value(id.path.startsWith('example/demo/') || id.path.startsWith('example/data/'));
  }
  
  Future apply(Transform transform) {
    var completer = new Completer();
    
    var id = transform.primaryInput.id;
    
    new File(id.path).readAsString().then((String content) {
      var filename = 'build/' + id.path;
      var directoryName = filename.substring(0, filename.lastIndexOf('/'));
      var directory = new Directory(directoryName);
      
      directory.exists().then((bool exists) {
        if (!exists) {
          directory.create(recursive: true).then((_) {
            new File(filename).writeAsString(content).then((_) {
              completer.complete();
            });
          });
        }
        else {
          new File(filename).writeAsString(content).then((_) {
            completer.complete();
          });
        }
      });
    });
    
    return completer.future;
  }
  
}