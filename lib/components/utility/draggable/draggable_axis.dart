part of draggable;

class DraggableAxis {
  final int _index;
  
  const DraggableAxis(int this._index);
  
  factory DraggableAxis.fromString(final String axis) {
    switch (axis) {
      case "x":
        return X;
      
      case "y":
        return Y;
      
      case "xy":
        return XY;
      
      default:
        throw new ArgumentError("Unknow axis: $axis");
    }
  }
  
  static const DraggableAxis X = const DraggableAxis(0);
  static const DraggableAxis Y = const DraggableAxis(1);
  static const DraggableAxis XY = const DraggableAxis(2);
  
  static const List<DraggableAxis> values = const [
    X,
    Y,
    XY
  ];
  
  String toString() {
    switch (_index) {
      case 0:
        return "x";
      
      case 1:
        return "y";
      
      case 2:
        return "xy";
      
      default:
        return "unknown";
    }
  }
}