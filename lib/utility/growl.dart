import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'growl_message.dart';

@CustomTag('h-growl')
class GrowlComponent extends PolymerElement {
  
  @published int lifetime = 0;
  @observable List<GrowlMessageModel> growlMessages = toObservable([]);
  StreamSubscription<CustomEvent> _streamSubscription;
  
  GrowlComponent.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    ContentElement content = $['hidden'].querySelector('content');
    List growlMessageComponents = content.getDistributedNodes();
    growlMessageComponents
      .map((GrowlMessageComponent component) => component.model)
      .forEach(addMessage);
    $['hidden'].remove();
    
    this._streamSubscription = window.on['growl'].listen((CustomEvent event) {
      addMessage(event.detail, prepend: true);
    });
  }
  
  @override
  void detached() {
    super.detached();
    
    this._streamSubscription.cancel();
  }
  
  void addMessage(GrowlMessageModel growlMessage, {bool prepend: false}) {
    if (prepend) {
      growlMessages.insert(0, growlMessage);
    }
    else {
      growlMessages.add(growlMessage);
    }
    
    if (lifetime > 0) {
      new Timer(new Duration(milliseconds: lifetime), () {
        removeMessage(growlMessage);
      });
    }
  }
  
  void removeMessage(GrowlMessageModel growlMessage) {
    int index = growlMessages.indexOf(growlMessage);
    
    this.shadowRoot.querySelectorAll('h-growl-message')[index].onClosing();
    
    new Timer(const Duration(milliseconds: GrowlMessageComponent.ANIMATION_DURATION), () {
      growlMessages.remove(growlMessage);
    });
  }
  
  void onGrowlMessageClosed(Event event, var detail, GrowlMessageComponent target) {
    int index = target.parent.children.indexOf(target);
    growlMessages.removeAt(index - 1);
  }
  
  static void postMessage(String summary, String detail, [String severity = 'info']) {
    GrowlMessageModel eventDetail = new GrowlMessageModel(summary, detail, severity);
    CustomEvent event = new CustomEvent('growl', detail: eventDetail);
    window.dispatchEvent(event);
  }
  
}