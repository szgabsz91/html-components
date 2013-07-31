part of growl;

class GrowlEventDetail {
  GrowlMessageModel message;
  
  GrowlEventDetail(GrowlMessageModel this.message);
  GrowlEventDetail.fromString(String str) {
    message = new GrowlMessageModel.fromString(str);
  }
  
  String toString() => message.toString();
}