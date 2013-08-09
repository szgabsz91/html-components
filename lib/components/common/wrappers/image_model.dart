part of wrappers;

class ImageModel extends Object with ObservableMixin {
  @observable String src;
  @observable String alt;
  @observable String title;
  
  ImageModel(String this.src, String this.alt, String this.title);
}