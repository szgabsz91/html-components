part of growl_message;

@observable
class GrowlMessageModel {
  String summary;
  String detail;
  GrowlMessageSeverity severity = new GrowlMessageSeverity.fromString("info");
  List<GrowlMessageListener> _listeners = <GrowlMessageListener>[];
  
  GrowlMessageModel();
  GrowlMessageModel.initialized(String this.summary, String this.detail, GrowlMessageSeverity this.severity);
  
  // for deserializing from window event detail
  GrowlMessageModel.fromString(String str) {
    List<String> parts = str.split("|||");
    summary = parts[0];
    detail = parts[1];
    severity = new GrowlMessageSeverity.fromString(parts[2]);
  }
  
  void addGrowlMessageListener(GrowlMessageListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }
  
  void removeGrowlMessageListener(GrowlMessageListener listener) {
    if (_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }
  
  void onClose() {
    _listeners.forEach((GrowlMessageListener listener) => listener.onGrowlMessageClosed(this));
  }
  
  // for serializing to window event detail (detail object must be string)
  String toString() => "${summary}|||${detail}|||${severity}";
}