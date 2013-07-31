library selectcheckboxmenu;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "selectitem.dart";

part "selectcheckboxmenu/model.dart";

class SelectCheckboxMenuComponent extends WebComponent {
  SelectCheckboxMenuModel model = new SelectCheckboxMenuModel();
  
  DivElement get _hiddenArea => this.query(".x-selectcheckboxmenu_ui-helper-hidden");
  List<DivElement> get _selectItemElements => _hiddenArea.queryAll('div[is="x-selectitem"]');
  DivElement get _menuRoot => this.query(".x-selectcheckboxmenu_ui-selectcheckboxmenu");
  DivElement get _panel => this.query(".x-selectcheckboxmenu_ui-selectcheckboxmenu-panel");
  DivElement get _selectAllCheckbox => this.query(".x-selectcheckboxmenu_ui-selectcheckboxmenu-header .x-selectcheckboxmenu_ui-chkbox-box");
  SpanElement get _selectAllCheckboxIcon => this.query(".x-selectcheckboxmenu_ui-selectcheckboxmenu-header span");
  
  static const EventStreamProvider<Event> _SELECT_CHANGED_EVENT = const EventStreamProvider<Event>("selectChanged");
  Stream<Event> get onSelectChanged => _SELECT_CHANGED_EVENT.forTarget(this);
  static void _dispatchSelectChangedEvent(Element element) {
    element.dispatchEvent(new Event("selectChanged"));
  }
  
  void inserted() {
    _selectItemElements.forEach((DivElement element) {
      SelectItemComponent selectItemComponent = element.xtag;
      model.items.add(selectItemComponent.model);
    });
    
    _hiddenArea.remove();
  }
  
  String get label => model.label;
  set label(String label) => model.label = label;
  
  String get queryexpression => model.queryExpression;
  set queryexpression(String queryexpression) => model.queryExpression = queryexpression;
  
  void _onMouseOver() {
    _menuRoot.classes.add("x-selectcheckboxmenu_ui-state-hover");
  }
  
  void _onMouseOut() {
    _menuRoot.classes.remove("x-selectcheckboxmenu_ui-state-hover");
  }
  
  void _onToggleClicked() {
    _panel.classes.toggle("x-selectcheckboxmenu_ui-helper-hidden");
  }
  
  void _onCloseClicked(MouseEvent event) {
    event.preventDefault();
    _panel.classes.add("x-selectcheckboxmenu_ui-helper-hidden");
  }
  
  void _onSelectAllClicked() {
    if (_selectAllCheckbox.classes.contains("x-selectcheckboxmenu_ui-state-active")) {
      deselectAll();
    }
    else {
      selectAll();
    }
    
    _dispatchSelectChangedEvent(this);
  }
  
  void _onClicked(SelectItemModel item) {
    if (item.selected) {
      deselect(item);
    }
    else {
      select(item);
    }
    
    _dispatchSelectChangedEvent(this);
  }
  
  void selectAll() {
    _selectAllCheckbox.classes.add("x-selectcheckboxmenu_ui-state-active");
    _selectAllCheckboxIcon.classes.addAll(["x-selectcheckboxmenu_ui-icon", "x-selectcheckboxmenu_ui-icon-check"]);
    model._visibleItems.forEach((SelectItemModel item) => item.selected = true);
  }
  
  void deselectAll() {
    _selectAllCheckbox.classes.remove("x-selectcheckboxmenu_ui-state-active");
    _selectAllCheckboxIcon.classes.removeAll(["x-selectcheckboxmenu_ui-icon", "x-selectcheckboxmenu_ui-icon-check"]);
    model._visibleItems.forEach((SelectItemModel item) => item.selected = false);
  }
  
  void select(SelectItemModel item) {
    item.selected = true;
  }
  
  void deselect(SelectItemModel item) {
    item.selected = false;
  }
}