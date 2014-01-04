import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'column.dart';
import 'tree/tree_node.dart';
import 'datatable/resizer.dart';
import 'treetable/data.dart';
import 'treetable/template.dart';
import '../common/null_tree_sanitizer.dart';

@CustomTag('h-treetable')
class TreetableComponent extends PolymerElement {
  
  @published Object root;
  @published String source;
  @published String selection = "none";
  
  @observable List<ColumnModel> columns = toObservable([]);
  @observable List<TreetableTemplateManager> columnTemplateManagers = toObservable([]);
  @observable String header;
  @observable String footer;
  @observable List selectedNodes = toObservable([]);
  @observable bool showColumnHeader = false;
  @observable bool showColumnFooter = false;
  
  TreetableDataFetcher _dataFetcher;
  bool _selectMultiple = false;
  Point _mousePosition;
  ColumnResizer _columnResizer = new ColumnResizer();
  
  TreetableComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    scheduleMicrotask(() {
      List<ColumnComponent> columnComponents = $['hidden'].querySelector('content').getDistributedNodes().where((Node node) => node is ColumnComponent).toList(growable: false);
      
      columnComponents.forEach((ColumnComponent columnComponent) {
        ColumnModel columnModel = columnComponent.model;
        columns.add(columnModel);
        columnTemplateManagers.add(new TreetableTemplateManager(columnModel.content));
      });
      
      Element headerElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element && node.tagName == 'HEADER', orElse: () => null);
      if (headerElement != null) {
        header = headerElement.innerHtml;
        showColumnHeader = true;
      }
      
      Element footerElement = $['hidden'].querySelector('content').getDistributedNodes().firstWhere((Node node) => node is Element && node.tagName == 'FOOTER', orElse: () => null);
      if (footerElement != null) {
        footer = footerElement.innerHtml;
        showColumnFooter = true;
      }
      
      $['hidden'].remove();
      
      document.onMouseMove.listen(_onColumnResizing);
      document.onMouseUp.listen(_onColumnResizeStopped);
      document.onKeyDown.listen(_onKeyDown);
      document.onKeyUp.listen(_onKeyUp);
      
      if (root != null) {
        _dataFetcher = new TreetableClientDataFetcher(root);
      }
      else if (source != null) {
        // URL
        Uri serviceURL = Uri.parse(source);
        _dataFetcher = new TreetableServerDataFetcher(serviceURL);
      }
      
      _insertMessage("Loading...", null, 0);
      _dataFetcher.fetchNodes(null).then((List<TreeNode> treeNodes) {
        _removeMessages();
        _insertTreeNodes(treeNodes, null, 0);
      }).catchError((Object error) => print("An error occured: $error"));
    });
  }
  
  void onColumnResizeStarted(MouseEvent event) {
    event.preventDefault();
    
    _mousePosition = new Point(event.page.x, event.page.y);
    SpanElement target = event.target;
    _columnResizer.resizingColumn = target.parent;
    document.body.style.cursor = "col-resize";
  }
  
  void _onColumnResizing(MouseEvent event) {
    if (_mousePosition == null || _columnResizer.resizingColumn == null) {
      return;
    }
    
    Point newPosition = new Point(event.page.x, event.page.y);
    _columnResizer.resize(newPosition.x - _mousePosition.x);
    
    _mousePosition = newPosition;
  }
  
  void _onColumnResizeStopped(MouseEvent event) {
    if (_mousePosition == null || _columnResizer.resizingColumn == null) {
      return;
    }
    
    _mousePosition = null;
    _columnResizer.resizingColumn = null;
    document.body.style.cursor = "auto";
    
    this.dispatchEvent(new Event('columnResized'));
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
  
  void _onMouseOverRow(MouseEvent event, TreeNode node) {
    if (selection == "none") {
      return;
    }
    
    if (selectedNodes.contains(node)) {
      return;
    }
    
    TableRowElement target =  event.currentTarget;
    target.classes.add("hover");
  }
  
  void _onMouseOutRow(MouseEvent event, TreeNode node) {
    if (selection == "none") {
      return;
    }
    
    TableRowElement target =  event.currentTarget;
    target.classes.remove("hover");
  }
  
  void _onRowClicked(MouseEvent event, TreeNode node) {
    if (selection == 'none') {
      return;
    }
    
    Element realTarget = event.target;
    if (realTarget.classes.contains("toggler")) {
      return;
    }
    
    event.preventDefault();
    
    TableRowElement target = event.currentTarget;
    
    if (selection == "multiple") {
      if (_selectMultiple) {
        if (selectedNodes.contains(node)) {
          selectedNodes.remove(node);
          target.classes.remove("selected");
          target.classes.add("hover");
        }
        else {
          selectedNodes.add(node);
          target.classes.remove("hover");
          target.classes.add("selected");
        }
      }
      else {
        if (!selectedNodes.contains(node)) {
          selectedNodes.clear();
          this.shadowRoot.querySelectorAll(".selected").forEach((Element element) => element.classes.remove("selected"));
          selectedNodes.add(node);
          target.classes.remove("hover");
          target.classes.add("selected");
        }
        else {
          selectedNodes.clear();
          this.shadowRoot.querySelectorAll(".selected").forEach((Element element) => element.classes.remove("selected"));
          target.classes.remove("hover");
        }
      }
    }
    else {
      selectedNodes = toObservable([node]);
      this.shadowRoot.querySelectorAll(".selected").forEach((Element element) => element.classes.remove("selected"));
      target.classes.add("selected");
      target.classes.remove("hover");
    }
    
    this.dispatchEvent(new CustomEvent('selected', detail: node.data));
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
    element.classes
      ..remove("triangle-1-e")
      ..add("triangle-1-s");
    
    TableRowElement row = element.parent.parent;
    int level = int.parse(row.attributes["data-level"]);
    TableRowElement nextRow = row.nextElementSibling;
    int nextLevel = -1;
    if (nextRow != null) {
      nextLevel = int.parse(nextRow.attributes["data-level"]);
    }
    
    if (nextLevel <= level) {
      _insertMessage("Loading...", row, level + 1);
      
      _dataFetcher.fetchNodes(node).then((List<TreeNode> treeNodes) {
        _removeMessages();
        
        _insertTreeNodes(treeNodes, row, level + 1);
      }).catchError((Object error) => print("An error occured: $error"));
    }
    else {
      while (nextRow != null && nextRow is TableRowElement && int.parse(nextRow.attributes["data-level"]) >= level + 1) {
        if (int.parse(nextRow.attributes["data-level"]) == level + 1 || nextRow.attributes["data-state"] == "visible") {
          nextRow.style.display = "table-row";
          nextRow.attributes["data-state"] = "visible";
        }
        
        nextRow = nextRow.nextElementSibling;
      }
    }
    
    node.expanded = true;
    
    this.dispatchEvent(new CustomEvent('expanded', detail: node.data));
  }
  
  void _collapseNode(TreeNode node, Element element) {
    element.classes
      ..remove("triangle-1-s")
      ..add("triangle-1-e");
    
    TableRowElement row = element.parent.parent;
    int level = int.parse(row.attributes["data-level"]);
    
    TableRowElement nextRow = row.nextElementSibling;
    while (nextRow != null && nextRow is TableRowElement && int.parse(nextRow.attributes["data-level"]) > level) {
      nextRow.style.display = "none";
      
      if (int.parse(nextRow.attributes["data-level"]) == level + 1) {
        nextRow.attributes["data-state"] = "invisible";
      }
      
      nextRow = nextRow.nextElementSibling;
    }
    
    node.expanded = false;
    
    this.dispatchEvent(new CustomEvent('collapsed', detail: node.data));
  }
  
  void _insertMessage(String message, Element previousElement, int level) {
    TableRowElement row = new TableRowElement();
    TableCellElement cell = new TableCellElement();
    
    cell
      ..text = message
      ..style.paddingLeft = "${10 + level * 16}px"
      ..colSpan = columns.length;
    row
      ..classes.add("message")
      ..children.add(cell);
    
    if (previousElement == null) {
      $['table-body'].children.add(row);
    }
    else {
      previousElement.insertAdjacentElement("afterEnd", row);
    }
  }
  
  void _removeMessages() {
    this.shadowRoot.querySelectorAll(".message").forEach((TableRowElement row) => row.remove());
  }
  
  void _insertTreeNodes(List<TreeNode> treeNodes, Element previousElement, int level) {
    List<TableRowElement> newRows = [];
    
    treeNodes.forEach((TreeNode treeNode) {
      TableRowElement row = new TableRowElement();
      row
        ..attributes["data-level"] = "$level"
        ..attributes["data-state"] = "visible"
        ..onMouseOver.listen((MouseEvent event) => _onMouseOverRow(event, treeNode))
        ..onMouseOut.listen((MouseEvent event) => _onMouseOutRow(event, treeNode))
        ..onClick.listen((MouseEvent event) => _onRowClicked(event, treeNode));
      
      for (int columnIndex = 0; columnIndex < columns.length; ++columnIndex) {
        ColumnModel column = columns[columnIndex];
        TreetableTemplateManager columnTemplateManager = columnTemplateManagers[columnIndex];
        
        TableCellElement cell = new TableCellElement();
        cell
          ..style.textAlign = column.textAlign
          ..setInnerHtml(columnTemplateManager.getSubstitutedString(treeNode.data), treeSanitizer: new NullTreeSanitizer());
        
        if (columnIndex == 0) {
          cell.style.paddingLeft = "${10 + level * 16}px";
          
          SpanElement toggler = new SpanElement();
          toggler.classes.addAll(["toggler", "triangle-1-e"]);
          
          if (treeNode.isParent) {
            toggler.onClick.listen((MouseEvent event) => _toggleNode(treeNode, event));
          }
          else {
            toggler.style.visibility = "hidden";
          }
          
          cell.insertAdjacentElement("afterBegin", toggler);
        }
        
        row.children.add(cell);
      }
      
      newRows.add(row);
    });
    
    if (previousElement == null) {
      $['table-body'].children.addAll(newRows);
    }
    else {
      for (int i = newRows.length - 1; i >= 0; --i) {
        previousElement.insertAdjacentElement("afterEnd", newRows[i]);
      }
    }
  }
  
}