import 'dart:html';
import 'dart:async';
import 'dart:convert';
import '../tree/tree_node.dart';

abstract class TreetableDataFetcher {
  TreeNode _root;
  
  TreetableDataFetcher(this._root);
  
  get root => _root;
  
  Future<List> fetchNodes(TreeNode parent);
}

class TreetableClientDataFetcher extends TreetableDataFetcher {
  TreetableClientDataFetcher(TreeNode root) : super(root);
  
  Future<List> fetchNodes(TreeNode parent) {
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
  
  TreetableServerDataFetcher(this._serviceURL) : super(null);
  
  Future<List> fetchNodes(TreeNode parent) {
    Completer completer = new Completer();
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        List mapList = JSON.decode(request.responseText);
        List result = [];
        
        for (Map<String, dynamic> item in mapList) {
          TreeNode node = new TreeNode(item["data"], parent);
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