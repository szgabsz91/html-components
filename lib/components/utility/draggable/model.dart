part of draggable;

@observable
class DraggableModel {
  int top = 0;
  int left = 0;
  String _axis = "xy";
  
  String get axis => _axis;
  set axis(String axis) {
    if (["xy", "x", "y"].contains(axis)) {
      _axis = axis;
    }
    else {
      throw new ArgumentError("The axis property must be x, y or xy!");
    }
  }
}