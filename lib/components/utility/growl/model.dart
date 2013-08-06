part of growl;

class GrowlModel extends Object with ObservableMixin {
  @observable int lifetime = 0;
  @observable ObservableList<GrowlMessageModel> messages = new ObservableList();
}