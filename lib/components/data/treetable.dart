library treetable;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "dart:json" as json;
import "column.dart";
import "common/tree.dart";
import "common/table.dart";
import "../common/templates.dart";
import "../common/converters.dart" as converters;

export "common/tree.dart";

part "treetable/data.dart";
part "treetable/model.dart";

class TreetableComponent extends WebComponent {
  TreetableModel model = new TreetableModel();
  
  Point _mousePosition;
  ColumnResizer _columnResizer = new ColumnResizer();
  
  DivElement get _hiddenArea => this.query(".x-treetable_ui-helper-hidden");
  List<DivElement> get _columnElemens => _hiddenArea.queryAll('div[is="x-column"]');
  Element get _headerElement => _hiddenArea.query("header");
  Element get _footerElement => _hiddenArea.query("footer");
  TableSectionElement get _tableBody => this.query(".x-treetable_ui-treetable-data");
  List<TableRowElement> get _highlightedRows => this.queryAll(".x-treetable_ui-state-highlight");
  List<TableRowElement> get _messageElements => this.queryAll(".x-treetable_message");
  
  static const EventStreamProvider<Event> _COLUMN_RESIZED_EVENT = const EventStreamProvider<Event>("columnResized");
  Stream<Event> get onColumnResized => _COLUMN_RESIZED_EVENT.forTarget(this);
  static void _dispatchColumnResizedEvent(Element element) {
    element.dispatchEvent(new Event("columnResized"));
  }
  
  static const EventStreamProvider<CustomEvent> _EXPANDED_EVENT = const EventStreamProvider<CustomEvent>("expanded");
  Stream<CustomEvent> get onExpanded => _EXPANDED_EVENT.forTarget(this);
  static void _dispatchExpandedEvent(Element element, Object data) {
    element.dispatchEvent(new CustomEvent("expanded", detail: data.toString()));
  }
  
  static const EventStreamProvider<CustomEvent> _COLLAPSED_EVENT = const EventStreamProvider<CustomEvent>("collapsed");
  Stream<CustomEvent> get onCollapsed => _COLLAPSED_EVENT.forTarget(this);
  static void _dispatchCollapsedEvent(Element element, Object data) {
    element.dispatchEvent(new CustomEvent("collapsed", detail: data.toString()));
  }
  
  static const EventStreamProvider<Event> _SELECTED_EVENT = const EventStreamProvider<Event>("selected");
  Stream<Event> get onSelected => _SELECTED_EVENT.forTarget(this);
  static void _dispatchSelectedEvent(Element element) {
    element.dispatchEvent(new Event("selected"));
  }
  
  void inserted() {
    Timer.run(() {
      _columnElemens.forEach((DivElement columnElement) {
        ColumnComponent columnComponent = columnElement.xtag;
        ColumnModel columnModel = columnComponent.model;
        model.columns.add(columnModel);
        model.columnTemplateManagers.add(new TemplateManager(columnModel.content.toString()));
      });
      
      if (_headerElement != null) {
        model.header = _headerElement.innerHtml;
      }
      
      if (_footerElement != null) {
        model.footer = _footerElement.innerHtml;
      }
      
      _hiddenArea.remove();
      
      document.onMouseMove.listen(_onColumnResizing);
      document.onMouseUp.listen(_onColumnResizeStopped);
      document.onKeyDown.listen(_onKeyDown);
      document.onKeyUp.listen(_onKeyUp);
      
      _insertMessage("Loading...", null, 0);
      model._dataFetcher.fetchNodes(null).then((List<TreeNode> treeNodes) {
        _removeMessages();
        _insertTreeNodes(treeNodes, null, 0);
      }).catchError((Object error) => print("An error occured: $error"));
    });
  }
  
  set root(var root) {
    if (root is TreeNode) {
      model._dataFetcher = new TreetableClientDataFetcher(root);
    }
    else if (root is String) {
      // URL
      Uri serviceURL = Uri.parse(root);
      model._dataFetcher = new TreetableServerDataFetcher(serviceURL);
    }
    else {
      throw new ArgumentError("The root property must be of type List or String!");
    }
  }
  
  String get selection => model.selection;
  set selection(String selection) => model.selection = selection;
  
  void _onColumnResizeStarted(MouseEvent event) {
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
  
  void _onColumnResizeStopped(MouseEvent _) {
    if (_mousePosition == null || _columnResizer.resizingColumn == null) {
      return;
    }
    
    _mousePosition = null;
    _columnResizer.resizingColumn = null;
    document.body.style.cursor = "auto";
    
    _dispatchColumnResizedEvent(this);
  }
  
  void _onKeyDown(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._multipleMode = true;
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    // Ctrl
    if (event.which == 17) {
      model._multipleMode = false;
    }
  }
  
  void _onMouseOverRow(MouseEvent event, TreeNode node) {
    if (model.selection == "none") {
      return;
    }
    
    if (model.selectedNodes.contains(node)) {
      return;
    }
    
    TableRowElement target =  event.currentTarget;
    target.classes.add("x-treetable_ui-state-hover");
  }
  
  void _onMouseOutRow(MouseEvent event, TreeNode node) {
    if (model.selection == "none") {
      return;
    }
    
    TableRowElement target =  event.currentTarget;
    target.classes.remove("x-treetable_ui-state-hover");
  }
  
  void _onRowClicked(MouseEvent event, TreeNode node) {
    if (model.selection == "none") {
      return;
    }
    
    Element realTarget = event.target;
    if (realTarget.classes.contains("x-treetable_ui-treetable-toggler")) {
      return;
    }
    
    event.preventDefault();
    
    TableRowElement target = event.currentTarget;
    
    if (model.selection == "multiple") {
      if (model._multipleMode) {
        if (model.selectedNodes.contains(node)) {
          model.selectedNodes.remove(node);
          target.classes.remove("x-treetable_ui-state-highlight");
          target.classes.add("x-treetable_ui-state-hover");
        }
        else {
          model.selectedNodes.add(node);
          target.classes.remove("x-treetable_ui-state-hover");
          target.classes.add("x-treetable_ui-state-highlight");
        }
      }
      else {
        if (!model.selectedNodes.contains(node)) {
          model.selectedNodes.clear();
          _highlightedRows.forEach((TableRowElement row) => row.classes.remove("x-treetable_ui-state-highlight"));
          model.selectedNodes.add(node);
          target.classes.remove("x-treetable_ui-state-hover");
          target.classes.add("x-treetable_ui-state-highlight");
        }
        else {
          model.selectedNodes.clear();
          _highlightedRows.forEach((TableRowElement row) => row.classes.remove("x-treetable_ui-state-highlight"));
          target.classes.add("x-treetable_ui-state-hover");
        }
      }
    }
    else {
      model.selectedNode = node;
      _highlightedRows.forEach((TableRowElement row) => row.classes.remove("x-treetable_ui-state-highlight"));
      target.classes.remove("x-treetable_ui-state-hover");
      target.classes.add("x-treetable_ui-state-highlight");
    }
    
    _dispatchSelectedEvent(this);
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
      ..remove("x-treetable_ui-icon-triangle-1-e")
      ..add("x-treetable_ui-icon-triangle-1-s");
    
    TableRowElement row = element.parent.parent;
    int level = int.parse(row.attributes["data-level"]);
    TableRowElement nextRow = row.nextElementSibling;
    int nextLevel = -1;
    if (nextRow != null) {
      nextLevel = int.parse(nextRow.attributes["data-level"]);
    }
    
    if (nextLevel <= level) {
      _insertMessage("Loading...", row, level + 1);
      
      model._dataFetcher.fetchNodes(node).then((List<TreeNode> treeNodes) {
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
    
    if (node.data is Map) {
      _dispatchExpandedEvent(this, converters.mapToString(node.data));
    }
    else {
      _dispatchExpandedEvent(this, node.data);
    }
  }
  
  void _collapseNode(TreeNode node, Element element) {
    element.classes
      ..remove("x-treetable_ui-icon-triangle-1-s")
      ..add("x-treetable_ui-icon-triangle-1-e");
    
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
    
    if (node.data is Map) {
      _dispatchCollapsedEvent(this, converters.mapToString(node.data));
    }
    else {
      _dispatchCollapsedEvent(this, node.data);
    }
  }
  
  void _insertMessage(String message, Element previousElement, int level) {
    TableRowElement row = new TableRowElement();
    TableCellElement cell = new TableCellElement();
    
    cell
      ..text = message
      ..style.paddingLeft = "${10 + level * 16}px"
      ..colSpan = model.columns.length;
    row
      ..classes.add("x-treetable_message")
      ..children.add(cell);
    
    if (previousElement == null) {
      _tableBody.children.add(row);
    }
    else {
      previousElement.insertAdjacentElement("afterEnd", row);
    }
  }
  
  void _removeMessages() {
    _messageElements.forEach((TableRowElement row) => row.remove());
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
      
      for (int columnIndex = 0; columnIndex < model.columns.length; ++columnIndex) {
        ColumnModel column = model.columns[columnIndex];
        TemplateManager columnTemplateManager = model.columnTemplateManagers[columnIndex];
        
        TableCellElement cell = new TableCellElement();
        cell
          ..style.textAlign = column.textAlign
          ..insertAdjacentHtml("afterBegin", columnTemplateManager.getSubstitutedString(treeNode.data));
        
        if (columnIndex == 0) {
          cell.style.paddingLeft = "${10 + level * 16}px";
          
          SpanElement toggler = new SpanElement();
          toggler.classes.addAll(["x-treetable_ui-treetable-toggler", "x-treetable_ui-icon", "x-treetable_ui-icon-triangle-1-e"]);
          
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
      _tableBody.children.addAll(newRows);
    }
    else {
      for (int i = newRows.length - 1; i >= 0; --i) {
        previousElement.insertAdjacentElement("afterEnd", newRows[i]);
      }
    }
  }
}