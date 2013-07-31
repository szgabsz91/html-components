part of resizable;

@observable
class ResizableModel {
  Size currentSize = new Size.zero();
  bool aspectRatio = false;
  bool ghost = false;
  Size minimumSize = new Size.zero();
  Size maximumSize = new Size(9999, 9999);
  double ratio = 1.0;
  ResizeMode resizeMode;
}