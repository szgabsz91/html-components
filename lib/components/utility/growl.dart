library growl;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";
import "growl_message.dart";

part "growl/model.dart";
part "growl/event_detail.dart";

class GrowlComponent extends WebComponent implements GrowlMessageListener {
  GrowlModel model = new GrowlModel();
  
  // TODO Replace into model
  @observable
  ObservableList<GrowlMessageModel> _messages = new ObservableList();
  
  DivElement get _hiddenArea => this.query(".x-growl_ui-helper-hidden");
  List<DivElement> get _growlMessageElements => this.queryAll('div[is="x-growl-message"]');
  DivElement _getGrowlMessageElementByIndex(int index) {
    return _growlMessageElements.elementAt(index);
  }
  
  void inserted() {
    _growlMessageElements.forEach((DivElement messageDiv) {
      GrowlMessageComponent growlMessageComponent = messageDiv.xtag;
      GrowlMessageModel growlMessageModel = growlMessageComponent.model;
      addMessage(growlMessageModel, append: true);
    });
    
    _hiddenArea.remove();
    
    window.on["growl"].listen((CustomEvent event) {
      GrowlMessageModel message;
      
      // in Dart VM, event.detail is String, in dart2js it is an object
      if (event.detail is String) {
        message = new GrowlEventDetail.fromString(event.detail).message;
      }
      else if (event.detail is GrowlEventDetail) {
        GrowlEventDetail detail = event.detail;
        message = detail.message;
      }
      
      addMessage(message);
    });
  }
  
  int get lifetime => model.lifetime;
  set lifetime(var lifetime) {
    if (lifetime is int) {
      model.lifetime = lifetime;
    }
    else if (lifetime is String) {
      model.lifetime = int.parse(lifetime);
    }
    else {
      throw new ArgumentError("The lifetime property must be of type int or String!");
    }
  }
  
  void addMessage(GrowlMessageModel message, {bool append: false}) {
    message.addGrowlMessageListener(this);
    
    if (append) {
      _messages.add(message);
    }
    else {
      _messages.insert(0, message);
    }
    
    if (model.lifetime > 0) {
      new Future.delayed(new Duration(milliseconds: model.lifetime), () {
        try {
          int index = _messages.indexOf(message);
          DivElement messageDiv = _getGrowlMessageElementByIndex(index);
          GrowlMessageComponent growlMessageComponent = messageDiv.xtag;
          growlMessageComponent.close();
        }
        on RangeError catch (error) {
          int index = _messages.length - 1;
          DivElement messageDiv = _getGrowlMessageElementByIndex(index);
          GrowlMessageComponent growlMessageComponent = messageDiv.xtag;
          growlMessageComponent.close();
        }
      });
    }
  }
  
  void onGrowlMessageClosed(GrowlMessageModel message) {
    _messages.remove(message);
  }
  
  static void postMessage(String summary, String detail, [String severity = "info"]) {
    GrowlMessageSeverity severityObject = new GrowlMessageSeverity.fromString(severity);
    GrowlMessageModel message = new GrowlMessageModel.initialized(summary, detail, severityObject);
    // toString is called because of a dart2js bug - Uncaught UnimplementedError: structured clone of other type
    window.dispatchEvent(new CustomEvent("growl", detail: new GrowlEventDetail(message).toString()));
  }
}