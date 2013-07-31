part of lightbox;

@observable
class LightboxModel {
  int currentIndex = -1;
  Size documentSize = new Size.zero();
  int windowHeight;
  Size currentSize = new Size(50, 50);
  bool hidden = true;
  String currentLabel = "";
}