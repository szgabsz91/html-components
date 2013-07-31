part of menubar;

@observable
class MenubarModel {
  String _orientation = "horizontal";
  
  String get orientation => _orientation;
  set orientation(String orientation) {
    if (["horizontal", "vertical"].contains(orientation)) {
      _orientation = orientation;
    }
    else {
      throw new ArgumentError("The orientation property must be horizontal or vertical!");
    }
  }
}