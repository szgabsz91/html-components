import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'tree_node.dart';

// Uncaught Error: type 'TreeNode' is not a subtype of type 'TreeNode' of 'root'.

abstract class TreeDataFetcher {
  var _root;
  
  TreeDataFetcher(this._root);
  
  get root => _root;
  
  Future<List> fetchNodes(var parent);
}

class TreeClientDataFetcher extends TreeDataFetcher {
  TreeClientDataFetcher(var root) : super(root);
  
  Future<List> fetchNodes(var parent) {
    Completer completer = new Completer();
    
    if (parent != null) {
      completer.complete(parent.children);
    }
    else {
      completer.complete(root.children);
    }
    
    return completer.future;
  }
}

class TreeServerDataFetcher extends TreeDataFetcher {
  Uri _serviceURL;
  
  TreeServerDataFetcher(Uri this._serviceURL) : super(null);
  
  Future<List> fetchNodes(var parent) {
    Completer completer = new Completer();
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        List mapList = JSON.decode(request.responseText);
        List result = [];
        
        for (Map<String, dynamic> item in mapList) {
          var node = new TreeNode(item["data"], parent);
          // TODO Place into constructor
          node.isParent = item["isParent"];
          result.add(node);
        }
        
        completer.complete(result);
      }
    });
    
    request.open("POST", _serviceURL.toString(), async: false);
    request.send(JSON.encode(parent));
    
    return completer.future;
  }
}