part of tab;

@observable
class TabModel {
  String label = "";
  bool selected = false;
  bool disabled = false;
  bool closable = false;
  bool _closed = false;
  String content = null;
  
  List<TabListener> listeners = [];
  
  bool get closed => _closed;
  
  SafeHtml get safeContent => new SafeHtml.unsafe("<div>${content}</div>");
  
  void addListener(TabListener listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }
  
  void removeListener(TabListener listener) {
    if (listeners.contains(listener)) {
      listeners.remove(listener);
    }
  }
  
  void toggle() {
    if (selected) {
      deselect();
    }
    else {
      select();
    }
  }
  
  void select() {
    if (selected) {
      return;
    }
    
    listeners.forEach((TabListener listener) => listener.onTabSelected(this));
  }
  
  void deselect() {
    if (!selected) {
      return;
    }
    
    selected = false;
    
    listeners.forEach((TabListener listener) => listener.onTabDeselected(this));
  }
  
  void close () {
    if (closed) {
      return;
    }
    
    listeners.forEach((TabListener listener) => listener.onTabClosed(this));
  }
}