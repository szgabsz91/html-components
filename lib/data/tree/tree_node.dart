class TreeNode<T> {
  String type;
  T data;
  List<TreeNode> _children = [];
  TreeNode _parent;
  bool expanded = false;
  bool isParent = false;
  
  TreeNode([T this.data = null, TreeNode parent = null, String this.type = null]) {
    if (parent != null) {
      this.parent = parent;
      parent.isParent = true;
    }
  }
  
  List<TreeNode> get children => _children;
  
  TreeNode get parent => _parent;
  set parent(TreeNode parent) {
    _parent = parent;
    parent.isParent = true;
    
    if (!parent.children.contains(this)) {
      parent.children.add(this);
    }
  }
  
  Map<String, Object> toJson() => {"data": data};
}

class StringTreeNode extends TreeNode<String> {
  StringTreeNode(String data, TreeNode parent, [String type = null]) : super(data, parent, type);
}