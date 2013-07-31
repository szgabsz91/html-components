part of tab;

abstract class TabListener {
  void onTabSelected(TabModel tab);
  void onTabDeselected(TabModel tab);
  void onTabClosed(TabModel tab);
}