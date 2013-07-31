library tree;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "dart:json" as json;
import "treenode.dart";
import "common/tree.dart";
import "../common/templates.dart";
import "package:animation/animation.dart" as animation;

export "common/tree.dart";

part "tree/data.dart";
part "tree/model.dart";
part "tree/template.dart";

class TreeComponent extends WebComponent {
  TreeModel model = new TreeModel();
  
  DivElement get _hiddenArea => this.query(".x-tree_ui-helper-hidden");
  UListElement get _treeContainer => this.query(".x-tree_ui-tree-container");
  List<DivElement> get _treeNodeElements => _hiddenArea.queryAll('div[is="x-treenode"]');
  List<SpanElement> get _highlightedItems => queryAll(".x-tree_ui-state-highlight");
  
  static const EventStreamProvider<CustomEvent> _EXPANDED_EVENT = const EventStreamProvider<CustomEvent>("expanded");
  Stream<Event> get onExpanded => _EXPANDED_EVENT.forTarget(this);
  static void _dispatchExpandedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("expanded", detail: label.toString()));
  }
  
  static const EventStreamProvider<CustomEvent> _COLLAPSED_EVENT = const EventStreamProvider<CustomEvent>("collapsed");
  Stream<Event> get onCollapsed => _COLLAPSED_EVENT.forTarget(this);
  static void _dispatchCollapsedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("collapsed", detail: label.toString()));
  }
  
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>("selected");
  Stream<Event> get onSelected => _SELECTED_EVENT.forTarget(this);
  static void _dispatchSelectedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("selected", detail: label.toString()));
  }
  
  static const EventStreamProvider<CustomEvent> _DESELECTED_EVENT = const EventStreamProvider<CustomEvent>("deselected");
  Stream<Event> get onDeselected => _DESELECTED_EVENT.forTarget(this);
  static void _dispatchDeselectedEvent(Element element, String label) {
    element.dispatchEvent(new CustomEvent("deselected", detail: label.toString()));
  }
  
  void inserted() {
    Timer.run(() {
      if (_treeNodeElements.isEmpty) {
        model._templateManagers[null] = new TreeTemplateManager("");
      }
      else {
        _treeNodeElements.forEach((DivElement template) {
          TreeNodeComponent treeNodeComponent = template.xtag;
          TreeNodeModel treeNodeModel = treeNodeComponent.model;
          
          model._templateManagers[treeNodeModel.type] = new TreeTemplateManager(template.innerHtml);
          model._treeNodeModels[treeNodeModel.type] = treeNodeModel;
        });
      }
      
      _treeContainer.text = "Loading...";
      model._fetcher.fetchNodes(null).then((List<TreeNode> treeNodes) {
        _treeContainer.text = "";
        _insertTreeNodes(_treeContainer, treeNodes);
      }).catchError((Object error) => print("An error occured: $error"));
      
      _hiddenArea.children.clear();
    });
    
    document.onKeyDown.listen(_onKeyDown);
    document.onKeyUp.listen(_onKeyUp);
  }
  
  TreeNode get root => model._fetcher.root;
  set root(var root) {
    if (root is TreeNode) {
      model._fetcher = new TreeClientDataFetcher(root);
    }
    else if (root is String) {
      // URL
      Uri serviceURL = Uri.parse(root);
      model._fetcher = new TreeServerDataFetcher(serviceURL);
    }
    else {
      throw new ArgumentError("The root property must be of type TreeNode or String!");
    }
  }
  
  bool get animate => model.animate;
  set animate(var animate) {
    if (animate is bool) {
      model.animate = animate;
    }
    else if (animate is String) {
      model.animate = animate == "true";
    }
    else {
      throw new ArgumentError("The animate property must be of type bool or String!");
    }
  }
  
  String get selection => model.selection;
  set selection(String selection) => model.selection = selection;
  
  void _onKeyDown(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._selectMultiple = true;
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._selectMultiple = false;
    }
  }
  
  void _toggleNode(TreeNode node, MouseEvent event) {
    SpanElement target = event.target;
    
    if (node.expanded) {
      _collapseNode(node, target);
    }
    else {
      _expandNode(node, target);
    }
  }
  
  void _expandNode(TreeNode node, Element element) {
    _dispatchExpandedEvent(this, node.data);
    
    element.classes
      ..remove("x-tree_ui-icon-triangle-1-e")
      ..add("x-tree_ui-icon-triangle-1-s");
    
    UListElement childContainer = element.parent.parent.query("ul");
    SpanElement loadIcon = element.parent.queryAll(".x-tree_ui-icon").last;
    SpanElement nodeIcon = element.parent.query(".x-tree_ui-treenode-icon");
    
    if (childContainer.children.isEmpty) {
      loadIcon.classes.add("x-tree_loading");
      
      model._fetcher.fetchNodes(node).then((List<TreeNode> treeNodes) {
        loadIcon.classes.remove("x-tree_loading");
        
        if (nodeIcon != null) {
          TreeNodeModel treeNodeModel = model.__treeNodeModels[node.type];
          if (node.expanded) {
            if (treeNodeModel.expandedIcon != null) {
              nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.expandedIcon}");
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.icon}");
            }
          }
          else {
            if (treeNodeModel.collapsedIcon != null) {
              nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.collapsedIcon}");
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.icon}");
            }
          }
        }
        
        _insertTreeNodes(childContainer, treeNodes);
        
        if (model.animate) {
          int height = childContainer.clientHeight == 0 ? int.parse(childContainer.style.height.replaceAll("px", "")) : childContainer.clientHeight;
          childContainer.style.height = "0";
          childContainer.style.display = "block";
          node.expanded = true;
          
          Map<String, Object> animationProperties = <String, Object>{
            "height": height
          };
          
          animation.animate(childContainer, duration: 500, properties: animationProperties).onComplete.listen((_) {
            childContainer.style.height = "auto";
          });
        }
        else {
          childContainer.style.display = "block";
          node.expanded = true;
        }
        
        if (nodeIcon != null) {
          TreeNodeModel treeNodeModel = model.__treeNodeModels[node.type];
          if (node.expanded) {
            if (treeNodeModel.expandedIcon != null) {
              nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.expandedIcon}");
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
            }
          }
          else {
            if (treeNodeModel.collapsedIcon != null) {
              nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.collapsedIcon}");
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
            }
          }
        }
      }).catchError((Object error) => print("An error occured: $error"));
    }
    else {
      if (model.animate) {
        int height = childContainer.clientHeight == 0 ? int.parse(childContainer.style.height.replaceAll("px", "")) : childContainer.clientHeight;
        childContainer.style.height = "0";
        childContainer.style.display = "block";
        node.expanded = true;
        
        Map<String, Object> animationProperties = <String, Object>{
          "height": height
        };
        
        animation.animate(childContainer, duration: 500, properties: animationProperties).onComplete.listen((_) {
          childContainer.style.height = "auto";
        });
      }
      else {
        childContainer.style.display = "block";
        node.expanded = true;
        
      }
      
      if (nodeIcon != null) {
        TreeNodeModel treeNodeModel = model.__treeNodeModels[node.type];
        if (node.expanded) {
          if (treeNodeModel.expandedIcon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.expandedIcon}");
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
          }
        }
        else {
          if (treeNodeModel.collapsedIcon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.collapsedIcon}");
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
          }
        }
      }
    }
  }
  
  void _collapseNode(TreeNode node, Element element) {
    _dispatchCollapsedEvent(this, node.data);
    
    element.classes
      ..remove("x-tree_ui-icon-triangle-1-s")
      ..add("x-tree_ui-icon-triangle-1-e");
    
    UListElement childContainer = element.parent.parent.query("ul");
    SpanElement nodeIcon = element.parent.query(".x-tree_ui-treenode-icon");
    
    if (nodeIcon != null) {
      TreeNodeModel treeNodeModel = model.__treeNodeModels[node.type];
      if (node.expanded) {
        if (treeNodeModel.expandedIcon != null) {
          nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.expandedIcon}");
        }
        else if (treeNodeModel.icon != null) {
          nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.icon}");
        }
      }
      else {
        if (treeNodeModel.collapsedIcon != null) {
          nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.collapsedIcon}");
        }
        else if (treeNodeModel.icon != null) {
          nodeIcon.classes.remove("x-tree_ui-icon-${treeNodeModel.icon}");
        }
      }
    }
    
    node.expanded = false;
    
    if (model.animate) {
      int height = childContainer.clientHeight;
      
      if (nodeIcon != null) {
        TreeNodeModel treeNodeModel = model.__treeNodeModels[node.type];
        if (node.expanded) {
          if (treeNodeModel.expandedIcon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.expandedIcon}");
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
          }
        }
        else {
          if (treeNodeModel.collapsedIcon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.collapsedIcon}");
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
          }
        }
      }
      
      Map<String, Object> animationProperties = <String, Object>{
        "height": 0
      };
      
      animation.animate(childContainer, duration: 500, properties: animationProperties).onComplete.listen((_) {
        childContainer.style.display = "none";
        childContainer.style.height = "${height}px";
      });
    }
    else {
      childContainer.style.display = "none";
      
      if (nodeIcon != null) {
        TreeNodeModel treeNodeModel = model.__treeNodeModels[node.type];
        if (node.expanded) {
          if (treeNodeModel.expandedIcon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.expandedIcon}");
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
          }
        }
        else {
          if (treeNodeModel.collapsedIcon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.collapsedIcon}");
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add("x-tree_ui-icon-${treeNodeModel.icon}");
          }
        }
      }
    }
  }
  
  void _onClicked(TreeNode node, MouseEvent event) {
    Element target = event.target;
    
    if (model.selection == "multiple") {
      if (model._selectMultiple) {
        if (model.selectedItems.contains(node)) {
          model.selectedItems.remove(node);
          _dispatchDeselectedEvent(this, node.data);
          target.classes.remove("x-tree_ui-state-highlight");
        }
        else {
          model.selectedItems.add(node);
          _dispatchSelectedEvent(this, node.data);
          target.classes.add("x-tree_ui-state-highlight");
        }
      }
      else {
        if (!model.selectedItems.contains(node)) {
          model.selectedItems.clear();
          _highlightedItems.forEach((Element element) => element.classes.remove("x-tree_ui-state-highlight"));
          model.selectedItems.add(node);
          _dispatchSelectedEvent(this, node.data);
          target.classes.add("x-tree_ui-state-highlight");
        }
        else {
          model.selectedItems.clear();
          _dispatchDeselectedEvent(this, node.data);
          _highlightedItems.forEach((Element element) => element.classes.remove("x-tree_ui-state-highlight"));
          target.classes.remove("x-tree_ui-state-highlight");
        }
      }
    }
    else {
      model.selectedItem = node;
      _dispatchSelectedEvent(this, node.data);
      _highlightedItems.forEach((Element element) => element.classes.remove("x-tree_ui-state-highlight"));
      target.classes.add("x-tree_ui-state-highlight");
    }
  }
  
  void _insertTreeNodes(Element parent, List<TreeNode> treeNodes) {
    parent.children.clear();
    
    treeNodes.forEach((TreeNode node) {
      TreeTemplateManager templateManager = model._templateManagers[node.type];
      TreeNodeModel treeNodeModel = model._treeNodeModels[node.type];
      
      if (templateManager != null) {
        LIElement treeNode = templateManager.getTreeNode(node, treeNodeModel, _toggleNode, _onClicked);
        parent.children.add(treeNode);
      }
    });
  }
}