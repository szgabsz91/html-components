part of draggable;

class DraggableModel extends Object with ObservableMixin {
  @observable int top = 0;
  @observable int left = 0;
  @observable DraggableAxis axis = DraggableAxis.XY;
}