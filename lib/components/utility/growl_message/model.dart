part of growl_message;

class GrowlMessageModel extends Object with ObservableMixin {
  @observable String summary;
  @observable String detail;
  @observable Severity severity;
  
  GrowlMessageModel();
  GrowlMessageModel.initialized(String this.summary, String this.detail, Severity this.severity);
  
  // for deserializing from window event detail
  GrowlMessageModel.fromString(String str) {
    List<String> parts = str.split("|||");
    summary = parts[0];
    detail = parts[1];
    severity = new Severity.fromString(parts[2]);
  }
  
  // for serializing to window event detail (detail object must be string)
  String toString() => "${summary}|||${detail}|||${severity}";
}