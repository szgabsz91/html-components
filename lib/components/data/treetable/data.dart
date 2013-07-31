part of treetable;

abstract class TreetableDataFetcher {
  TreeNode _root;
  
  TreetableDataFetcher(TreeNode this._root);
  
  TreeNode get root => _root;
  
  Future<List<TreeNode>> fetchNodes(TreeNode parent);
}

class TreetableClientDataFetcher extends TreetableDataFetcher {
  TreetableClientDataFetcher(TreeNode root) : super(root);
  
  Future<List<TreeNode>> fetchNodes(TreeNode parent) {
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
  
  Future<List<TreeNode>> fetchNodes(TreeNode parent) {
    Completer completer = new Completer();
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        List mapList = json.parse(request.responseText);
        List<TreeNode> result = [];
        
        for (Map<String, dynamic> item in mapList) {
          TreeNode node = new TreeNode(item["data"], parent);
          // TODO Place into constructor
          node.isParent = item["isParent"];
          result.add(node);
        }
        
        completer.complete(result);
      }
    });
    
    request.open("POST", _serviceURL.toString(), async: false);
    request.send(json.stringify(parent));
    
    return completer.future;
  }
}