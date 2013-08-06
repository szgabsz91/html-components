library growl;

import "package:polymer/polymer.dart";
import "dart:html";
import "dart:async";
import "growl_message.dart";
import "../common/enums.dart";

part "growl/model.dart";
part "growl/event_detail.dart";

@CustomTag("h-growl")
class GrowlComponent extends PolymerElement with ObservableMixin {
  @observable GrowlModel model = new GrowlModel();
  
  DivElement get _hiddenArea => getShadowRoot("h-growl").query(".ui-helper-hidden");
  List<DivElement> get _growlMessageElements => host.queryAll("h-growl-message");
  TemplateElement get _repeatTemplate => getShadowRoot("h-growl").query("#repeatTemplate");
  DivElement _getGrowlMessageElementByIndex(int index) {
    return _growlMessageElements.elementAt(index);
  }
  
  void inserted() {
    new Future.delayed(const Duration(milliseconds: 0), () {
      _growlMessageElements.forEach((Element growlMessageElement) {
        var growlMessageComponent = growlMessageElement.xtag;
        var growlMessageModel = growlMessageComponent.model;
        addMessage(growlMessageModel, append: true);
      });
      
      _hiddenArea.remove();
      
      _repeatTemplate.model = model.messages;
    });
    
    window.on["growl"].listen((CustomEvent event) {
      GrowlMessageModel message = new GrowlEventDetail.fromString(event.detail).message;
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
  
  void addMessage(var message, {bool append: false}) {
    if (append) {
      model.messages.add(message);
    }
    else {
      model.messages.insert(0, message);
    }
    
    if (model.lifetime > 0) {
      new Future.delayed(new Duration(milliseconds: model.lifetime), () {
        try {
          int index = model.messages.indexOf(message);
          DivElement messageDiv = _getGrowlMessageElementByIndex(index);
          GrowlMessageComponent growlMessageComponent = messageDiv.xtag;
          growlMessageComponent.close();
        }
        on RangeError catch (error) {
          int index = model.messages.length - 1;
          DivElement messageDiv = _getGrowlMessageElementByIndex(index);
          GrowlMessageComponent growlMessageComponent = messageDiv.xtag;
          growlMessageComponent.close();
        }
      });
    }
  }
  
  void onGrowlMessageClosed(Event event, var detail, Element target) {
    var growlMessageComponent = target.xtag;
    var growlMessageModel = growlMessageComponent.model;
    model.messages.remove(growlMessageModel);
  }
  
  static void postMessage(String summary, String detail, [String severity = "info"]) {
    Severity severityObject = new Severity.fromString(severity);
    GrowlMessageModel message = new GrowlMessageModel.initialized(summary, detail, severityObject);
    // toString is called because only serialized objects can be event details
    window.dispatchEvent(new CustomEvent("growl", detail: new GrowlEventDetail(message).toString()));
  }
}