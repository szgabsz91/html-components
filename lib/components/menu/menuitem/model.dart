part of menuitem;

@observable
class MenuItemModel {
  String url = "#";
  String icon;
  String target = "_self";
  
  bool get _isExternal => url != "#";
}