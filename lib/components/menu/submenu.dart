library submenu;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "menubar.dart";

part "submenu/model.dart";

class SubmenuComponent extends WebComponent {
  SubmenuModel model = new SubmenuModel();
  
  LIElement get _rootElement => this.query(".x-submenu_ui-menuitem");
  AnchorElement get _anchorElement => this.query("a");
  UListElement get _childContainer => this.query("ul");
  LIElement get _contentContainer => this.query("ul li");
  SpanElement get _openIcon => this.query(".x-submenu_ui-icon-open");
  
  void inserted() {
    if (_contentContainer.children.length > 0) {
      _contentContainer.classes.add("x-submenu_ui-menu-parent");
    }
    
    if (this.parent.parent.parent.attributes["is"] == "x-menubar") {
      // Timer is needed because child submenu is inserted before parent menubar
      Timer.run(() {
        MenubarComponent menubarComponent = this.parent.parent.parent.xtag;
        
        if (menubarComponent.orientation == "horizontal") {
          // Fix arrow in horizontal menu
          _openIcon.classes
            ..remove("x-submenu_ui-icon-triangle-1-e")
            ..add("x-submenu_ui-icon-triangle-1-s");
          
          // Fix drop-down menu
          _childContainer.classes
            ..remove("x-submenu_drop-left")
            ..add("x-submenu_drop-down");
          
          // Fix menuitem width
          _rootElement.style.width = "auto";
          
          // Fix margin
          this.style.marginRight = "5px";
        }
      });
    }
  }
  
  String get label => model.label;
  set label(String label) => model.label = label;
  
  String get icon => model.icon;
  set icon(String icon) => model.icon = icon;
  
  void _onMouseOver() {
    _anchorElement.classes.add("x-submenu_ui-state-hover");
    _childContainer.classes.remove("x-submenu_ui-helper-hidden");
  }
  
  void _onMouseOut() {
    _anchorElement.classes.remove("x-submenu_ui-state-hover");
    _childContainer.classes.add("x-submenu_ui-helper-hidden");
  }
}