part of tree;

class TreeTemplateManager extends TemplateManager {
  TreeTemplateManager(String template) : super(template);
  
  String getSubstitutedString(Object object) {
    if (object is String) {
      return object;
    }
    
    return super.getSubstitutedString(object);
  }
  
  LIElement getTreeNode(TreeNode node, TreeNodeModel treeNodeModel, void expandCallback(TreeNode node, MouseEvent event), void clickCallback(TreeNode node, MouseEvent event)) {
    String base = getSubstitutedString(node.data);
    
    LIElement nodeElement = new LIElement();
    nodeElement.classes.add("x-tree_ui-treenode");
    
    SpanElement nodeContainer = new SpanElement();
    
    SpanElement toggler = new SpanElement();
    toggler.classes.addAll(["x-tree_ui-tree-toggler", "x-tree_ui-icon"]);
    if (node.isParent) {
      toggler.classes.add(node.expanded ? "x-tree_ui-icon-triangle-1-s" : "x-tree_ui-icon-triangle-1-e");
      toggler.onClick.listen((MouseEvent event) => expandCallback(node, event));
    }
    else {
      toggler.classes.add("x-tree_hidden-toggler");
    }
    nodeContainer.children.add(toggler);
    
    if (treeNodeModel != null && (treeNodeModel.icon != null || treeNodeModel.collapsedIcon != null || treeNodeModel.expandedIcon != null)) {
      SpanElement icon = new SpanElement();
      String iconClass = "";
      if (node.expanded && treeNodeModel.expandedIcon != null) {
        iconClass = treeNodeModel.expandedIcon;
      }
      else if (!node.expanded && treeNodeModel.collapsedIcon != null) {
        iconClass = treeNodeModel.collapsedIcon;
      }
      else if (treeNodeModel.icon != null) {
        iconClass = treeNodeModel.icon;
      }
      icon.classes.addAll(["x-tree_ui-treenode-icon", "x-tree_ui-icon", "x-tree_ui-icon-${iconClass}"]);
      nodeContainer.children.add(icon);
    }
    
    SpanElement label = new SpanElement();
    label
      ..classes.addAll(["x-tree_ui-treenode-label", "x-tree_ui-corner-all"])
      ..text = base
      ..onMouseOver.listen((MouseEvent event) => label.classes.add("x-tree_ui-state-hover"))
      ..onMouseOut.listen((MouseEvent event) => label.classes.remove("x-tree_ui-state-hover"))
      ..onClick.listen((MouseEvent event) => clickCallback(node, event));
    
    nodeContainer.children.add(label);
    
    UListElement nodeChildren = new UListElement();
    nodeChildren.classes.add("x-tree_ui-treenode-children");
    
    nodeElement.children.addAll([nodeContainer, nodeChildren]);
    
    return nodeElement;
  }
}