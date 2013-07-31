part of maskedinput;

@observable
class MaskedInputModel {
  String mask;
  String placeholderChar = "_";
  String value = "";
  
  bool get isValid => !value.contains(placeholderChar);
}