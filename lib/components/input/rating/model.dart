part of rating;

@observable
class RatingModel {
  int stars = 5;
  bool cancelable = true;
  bool readonly = false;
  bool disabled = false;
  int value = 0;
}