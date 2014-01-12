import 'dart:html';
import 'dart:async';
import 'dart:convert';
import '../tree/tree_node.dart';

// Uncaught Error: type 'TreeNode' is not a subtype of type 'TreeNode' of 'root'.

abstract class TreetableDataFetcher {
  var _root;
  
  TreetableDataFetcher(var this._root);
  
  get root => _root;
  
  Future<List> fetchNodes(var parent);
}

class TreetableClientDataFetcher extends TreetableDataFetcher {
  TreetableClientDataFetcher(var root) : super(root);
  
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

class TreetableServerDataFetcher extends TreetableDataFetcher {
  Uri _serviceURL;
  
  TreetableServerDataFetcher(Uri this._serviceURL) : super(null);
  
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