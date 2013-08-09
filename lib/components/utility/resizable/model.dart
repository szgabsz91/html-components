part of resizable;

class ResizableModel extends Object with ObservableMixin {
  @observable Size currentSize = new Size.zero();
  @observable bool aspectRatio = false;
  @observable bool ghost = false;
  @observable Size minimumSize = new Size.zero();
  @observable Size maximumSize = new Size(9999, 9999);
  @observable double ratio = 1.0;
  @observable ResizeMode resizeMode;
}