part of accordion;

@observable
class AccordionModel {
  String _selection = "single";
  List<Object> data;
  ObservableList<TabModel> _tabs = new ObservableList();
  
  String get selection => _selection;
  set selection(String selection) {
    if (selection == "single" || selection == "multiple") {
      _selection = selection;
    }
    else {
      throw new ArgumentError("The selection property must be single or multiple!");
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