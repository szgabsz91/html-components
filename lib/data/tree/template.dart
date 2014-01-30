import 'dart:html';
import 'tree_node.dart';
import '../tree_node/model.dart';
import '../../common/reflection.dart' as reflection;

// Uncaught Error: type 'TreeNode' is not a subtype of type 'TreeNode' of 'root'.

class TreeTemplateManager {
  
  String _template;
  List<String> _placeholders;
  
  TreeTemplateManager(String template) {
    this._template = template.replaceAllMapped(new RegExp(r"<img[^>]*(>)"), (Match match) {
      String target = match.group(0);
      return target.substring(0, target.length - 1) + "/>";
    });
    
    RegExp regExp = new RegExp(r"(\${[^\$^\s]+})");
    _placeholders = regExp.allMatches(template).map((Match match) => match.group(0)).toList(growable: false);
  }
  
  String getSubstitutedString(Object object) {
    if (object is String) {
      return object;
    }
    
    String record = _template;
    
    _placeholders.forEach((String placeholder) {
      String propertyName = placeholder.substring(2, placeholder.length - 1);
      
      if (propertyName.contains(":")) {
        return;
      }
      
      var propertyValue = reflection.getPropertyValue(object, propertyName);
      record = record.replaceAll(placeholder, propertyValue.toString());
    });
    
    return record;
  }
  
  LIElement getTreeNode(var node, TreeNodeModel treeNodeModel, void expandCallback(var node, MouseEvent event), void clickCallback(var node, MouseEvent event)) {
    String base = getSubstitutedString(node.data);
    
    LIElement nodeElement = new LIElement();
    nodeElement.classes.add("node");
    
    SpanElement nodeContainer = new SpanElement();
    
    SpanElement toggler = new SpanElement();
    toggler.classes.addAll(["toggler", "icon"]);
    if (node.isParent) {
      toggler.classes.add(node.expanded ? "triangle-1-s" : "triangle-1-e");
      toggler.onClick.listen((MouseEvent event) => expandCallback(node, event));
    }
    else {
      toggler.classes.add("hidden-toggler");
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
      icon.classes.addAll(["node-icon", "icon", iconClass]);
      nodeContainer.children.add(icon);
    }
    
    SpanElement label = new SpanElement();
    label
      ..classes.addAll(["node-label"])
      ..text = base
      ..onMouseOver.listen((MouseEvent event) => label.classes.add("hover"))
      ..onMouseOut.listen((MouseEvent event) => label.classes.remove("hover"))
      ..onClick.listen((MouseEvent event) => clickCallback(node, event));
    
    nodeContainer.children.add(label);
    
    UListElement nodeChildren = new UListElement();
    nodeChildren.classes.add("node-children");
    
    nodeElement.children.addAll([nodeContainer, nodeChildren]);
    
    return nodeElement;
  }
}