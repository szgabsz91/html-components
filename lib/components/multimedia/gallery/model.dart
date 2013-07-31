part of gallery;

@observable
class GalleryModel {
  int delay = 3000;
  ObservableList<ImageModel> images = new ObservableList();
  Size imageSize = new Size.zero();
  int currentIndex = 0;
  String currentTitle= "";
  String currentAlt = "";
}