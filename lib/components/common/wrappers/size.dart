part of wrappers;

class Size extends Object with ObservableMixin {
  @observable int width = 0;
  @observable int height = 0;
  
  Size.zero();
  Size(int this.width, int this.height);
}