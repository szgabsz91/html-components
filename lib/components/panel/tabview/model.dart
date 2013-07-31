part of tabview;

@observable
class TabviewModel {
  String _orientation = "top";
  List<Object> data;
  ObservableList<TabModel> _tabs = new ObservableList();
  
  String get orientation => _orientation;
  set orientation(String orientation) {
    if (["top", "bottom", "left", "right"].contains(orientation)) {
      _orientation = orientation;
    }
    else {
      throw new ArgumentError("The orientation property must be top, bottom, left or right!");
    }
  }
  
  ObservableList<TabModel> get tabs => _tabs;
  set tabs(List<TabModel> tabs) {
    if (tabs is ObservableList) {
      _tabs = tabs;
    }
    else {
      _tabs = toObservable(tabs);
    }
  }
}