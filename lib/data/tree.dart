import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'tree/data.dart';
import 'tree_node.dart';
import 'tree/template.dart';
import 'tree/tree_node.dart';

export 'tree/tree_node.dart';

@CustomTag('h-tree')
class TreeComponent extends PolymerElement {
  
  @published Object root;
  @published String source;
  @published String selection = 'single';
  @published bool animating = false;
  
  @observable List selectedItems = toObservable([]);
  
  bool _selectMultiple = false;
  TreeDataFetcher _dataFetcher;
  Map<String, TreeTemplateManager> _templateManagers = {};
  Map<String, TreeNodeModel> _treeNodeModels = {};
  
  TreeComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    if (root != null) {
      _dataFetcher = new TreeClientDataFetcher(root);
    }
    else if (source != null) {
      Uri serviceURL = Uri.parse(source);
      _dataFetcher = new TreeServerDataFetcher(serviceURL);
    }
    
    List<TreeNodeComponent> treeNodes = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is TreeNodeComponent).toList(growable: false);
    
    if (treeNodes.isEmpty) {
      _templateManagers[null] = new TreeTemplateManager('');
    }
    else {
      treeNodes.forEach((TreeNodeComponent treeNode) {
        TreeNodeModel treeNodeModel = treeNode.model;
        
        _templateManagers[treeNodeModel.type] = new TreeTemplateManager(treeNode.innerHtml);
        _treeNodeModels[treeNodeModel.type] = treeNodeModel;
      });
    }
    
    $['node-container'].text = 'Loading...';
    
    _dataFetcher.fetchNodes(null).then((List treeNodes) {
      $['node-container'].text = '';
      _insertTreeNodes($['node-container'], treeNodes);
    }).catchError((Object error) => print("An error occured: $error"));
    
    $['hidden'].remove();
    
    document.onKeyDown.listen(_onKeyDown);
    document.onKeyUp.listen(_onKeyUp);
  }
  
  void _onKeyDown(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      _selectMultiple = true;
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      _selectMultiple = false;
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
    this.dispatchEvent(new CustomEvent('expanded', detail: node.data));
    
    element.classes
      ..remove("triangle-1-e")
      ..add("triangle-1-s");
    
    UListElement childContainer = element.parent.parent.querySelector("ul");
    SpanElement loadIcon = element.parent.querySelectorAll(".icon").last;
    SpanElement nodeIcon = element.parent.querySelector(".node-icon");
    
    if (childContainer.children.isEmpty) {
      loadIcon.classes.add("loading");
      
      _dataFetcher.fetchNodes(node).then((List treeNodes) {
        loadIcon.classes.remove("loading");
        
        if (nodeIcon != null) {
          TreeNodeModel treeNodeModel = _treeNodeModels[node.type];
          if (node.expanded) {
            if (treeNodeModel.expandedIcon != null) {
              nodeIcon.classes.remove(treeNodeModel.expandedIcon);
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.remove(treeNodeModel.icon);
            }
          }
          else {
            if (treeNodeModel.collapsedIcon != null) {
              nodeIcon.classes.remove(treeNodeModel.collapsedIcon);
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.remove(treeNodeModel.icon);
            }
          }
        }
        
        _insertTreeNodes(childContainer, treeNodes);
        
        if (animating) {
          int height = childContainer.clientHeight == 0 ? int.parse(childContainer.attributes['data-height']) : childContainer.clientHeight;
          childContainer.style.maxHeight = "0";
          childContainer.style.display = "block";
          node.expanded = true;
          
          new Timer(const Duration(milliseconds: 50), () {
            childContainer.style.maxHeight = '${height}px';
            new Timer(const Duration(milliseconds: 250), () {
              childContainer.attributes['data-height'] = '${height}';
              childContainer.style.maxHeight = 'none';
            });
          });
        }
        else {
          childContainer.style.display = "block";
          node.expanded = true;
        }
        
        if (nodeIcon != null) {
          TreeNodeModel treeNodeModel = _treeNodeModels[node.type];
          if (node.expanded) {
            if (treeNodeModel.expandedIcon != null) {
              nodeIcon.classes.add(treeNodeModel.expandedIcon);
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.add(treeNodeModel.icon);
            }
          }
          else {
            if (treeNodeModel.collapsedIcon != null) {
              nodeIcon.classes.add(treeNodeModel.collapsedIcon);
            }
            else if (treeNodeModel.icon != null) {
              nodeIcon.classes.add(treeNodeModel.icon);
            }
          }
        }
      }).catchError((Object error) => print("An error occured: $error"));
    }
    else {
      if (animating) {
        int height = childContainer.clientHeight == 0 ? int.parse(childContainer.attributes['data-height']) : childContainer.clientHeight;
        childContainer.style.maxHeight = "0";
        childContainer.style.display = "block";
        node.expanded = true;
        
        new Timer(const Duration(milliseconds: 50), () {
          childContainer.style.maxHeight = '${height}px';
          new Timer(const Duration(milliseconds: 250), () {
            childContainer.attributes['data-height'] = '${height}';
            childContainer.style.maxHeight = 'none';
          });
        });
      }
      else {
        childContainer.style.display = "block";
        node.expanded = true;
      }
      
      if (nodeIcon != null) {
        TreeNodeModel treeNodeModel = _treeNodeModels[node.type];
        if (node.expanded) {
          if (treeNodeModel.expandedIcon != null) {
            nodeIcon.classes.add(treeNodeModel.expandedIcon);
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add(treeNodeModel.icon);
          }
        }
        else {
          if (treeNodeModel.collapsedIcon != null) {
            nodeIcon.classes.add(treeNodeModel.collapsedIcon);
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add(treeNodeModel.icon);
          }
        }
      }
    }
  }
  
  void _collapseNode(TreeNode node, Element element) {
    this.dispatchEvent(new CustomEvent('collapsed', detail: node.data));
    
    element.classes
      ..remove("triangle-1-s")
      ..add("triangle-1-e");
    
    UListElement childContainer = element.parent.parent.querySelector("ul");
    SpanElement nodeIcon = element.parent.querySelector(".node-icon");
    
    if (nodeIcon != null) {
      TreeNodeModel treeNodeModel = _treeNodeModels[node.type];
      if (node.expanded) {
        if (treeNodeModel.expandedIcon != null) {
          nodeIcon.classes.remove(treeNodeModel.expandedIcon);
        }
        else if (treeNodeModel.icon != null) {
          nodeIcon.classes.remove(treeNodeModel.icon);
        }
      }
      else {
        if (treeNodeModel.collapsedIcon != null) {
          nodeIcon.classes.remove(treeNodeModel.collapsedIcon);
        }
        else if (treeNodeModel.icon != null) {
          nodeIcon.classes.remove(treeNodeModel.icon);
        }
      }
    }
    
    node.expanded = false;
    
    if (animating) {
      int height = childContainer.clientHeight;
      
      if (nodeIcon != null) {
        TreeNodeModel treeNodeModel = _treeNodeModels[node.type];
        if (node.expanded) {
          if (treeNodeModel.expandedIcon != null) {
            nodeIcon.classes.add(treeNodeModel.expandedIcon);
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add(treeNodeModel.icon);
          }
        }
        else {
          if (treeNodeModel.collapsedIcon != null) {
            nodeIcon.classes.add(treeNodeModel.collapsedIcon);
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add(treeNodeModel.icon);
          }
        }
      }
      
      childContainer.style.maxHeight = '${height}px';
      new Timer(const Duration(milliseconds: 50), () {
        childContainer.style.maxHeight = '0';
        new Timer(const Duration(milliseconds: 250), () {
          childContainer.style.display = 'none';
          childContainer.style.maxHeight = '${height}px';
        });
      });
    }
    else {
      childContainer.style.display = "none";
      
      if (nodeIcon != null) {
        TreeNodeModel treeNodeModel = _treeNodeModels[node.type];
        if (node.expanded) {
          if (treeNodeModel.expandedIcon != null) {
            nodeIcon.classes.add(treeNodeModel.expandedIcon);
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add(treeNodeModel.icon);
          }
        }
        else {
          if (treeNodeModel.collapsedIcon != null) {
            nodeIcon.classes.add(treeNodeModel.collapsedIcon);
          }
          else if (treeNodeModel.icon != null) {
            nodeIcon.classes.add(treeNodeModel.icon);
          }
        }
      }
    }
  }
  
  void _onClicked(TreeNode node, MouseEvent event) {
    Element target = event.target;
    
    if (selection == "multiple") {
      if (_selectMultiple) {
        if (selectedItems.contains(node)) {
          selectedItems.remove(node);
          this.dispatchEvent(new CustomEvent('deselected', detail: node.data));
          target.classes.remove('selected');
        }
        else {
          selectedItems.add(node);
          this.dispatchEvent(new CustomEvent('selected', detail: node.data));
          target.classes.add("selected");
        }
      }
      else {
        if (!selectedItems.contains(node)) {
          selectedItems.clear();
          this.shadowRoot.querySelectorAll(".selected").forEach((Element element) => element.classes.remove("selected"));
          selectedItems.add(node);
          this.dispatchEvent(new CustomEvent('selected', detail: node.data));
          target.classes.add("selected");
        }
        else {
          selectedItems.clear();
          this.dispatchEvent(new CustomEvent('deselected', detail: node.data));
          this.shadowRoot.querySelectorAll(".selected").forEach((Element element) => element.classes.remove("selected"));
          target.classes.remove("selected");
        }
      }
    }
    else {
      selectedItems = toObservable([node]);
      this.dispatchEvent(new CustomEvent('selected', detail: node.data));
      this.shadowRoot.querySelectorAll(".selected").forEach((Element element) => element.classes.remove("selected"));
      target.classes.add("selected");
    }
  }
  
  void _insertTreeNodes(Element parent, List treeNodes) {
    parent.children.clear();
    
    treeNodes.forEach((TreeNode node) {
      TreeTemplateManager templateManager = _templateManagers[node.type];
      TreeNodeModel treeNodeModel = _treeNodeModels[node.type];
      
      if (templateManager != null) {
        LIElement treeNode = templateManager.getTreeNode(node, treeNodeModel, _toggleNode, _onClicked);
        parent.children.add(treeNode);
      }
    });
  }
  
}