part of resizable;

class ResizeMode {
  final int _index;
  
  const ResizeMode(int this._index);
  
  static const RESIZE_WIDTH = const ResizeMode(0);
  static const RESIZE_HEIGHT = const ResizeMode(1);
  static const RESIZE_BOTH = const ResizeMode(2);
  
  static const values = const [
    RESIZE_WIDTH,
    RESIZE_HEIGHT,
    RESIZE_BOTH
  ];
  
  static String _indexToString(final int index) {
    switch (index) {
      case 0:
        return "RESIZE_WIDTH";
      
      case 1:
        return "RESIZE_HEIGHT";
      
      case 2:
        return "RESIZE_BOTH";
      
      default:
        return "UNKNOWN";
    }
  }
  
  String toString() => "ResizeMode($_index)";
}