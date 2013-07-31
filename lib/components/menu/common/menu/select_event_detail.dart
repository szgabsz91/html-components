part of menu;

class SelectEventDetail {
  String selectedLabel;
  
  SelectEventDetail(String this.selectedLabel);
  // for deserializing from window event detail
  SelectEventDetail.fromString(String this.selectedLabel);
  
  String toString() => selectedLabel;
}