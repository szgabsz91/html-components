part of tag;

class TagModel {
  String label = "";
  String url = "#";
  int strength = 1;
  
  bool get isExternal => url != "#";
}