library rowexpansion;

import "package:web_ui/web_ui.dart";
import "dart:html";

part "rowexpansion/model.dart";

class RowExpansionComponent extends WebComponent {
  RowExpansionModel model = new RowExpansionModel();
  
  DivElement get _hiddenArea => this.query(".x-rowexpansion_ui-helper-hidden");
  
  void inserted() {
    model.content = _hiddenArea.innerHtml;
    _hiddenArea.remove();
  }
}