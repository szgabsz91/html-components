import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:html_components/html_components.dart' show SelectButtonComponent;

class ItemModel {
  String label;
  String value;
  
  ItemModel(this.label, this.value);
}

@CustomTag('showcase-collection')
class ShowcaseCollection extends PolymerElement {
  
  List<ItemModel> _items = toObservable([]);
  String hashPrefix;
  @observable String subpage;
  StreamSubscription<Event> _hashChangeListener;
  
  ShowcaseCollection.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    this._hashChangeListener = window.onHashChange.listen((_) {
      if (window.location.hash.isNotEmpty) {
        _refreshSubpage();
      }
    });
    
    if (window.location.hash.split('/').length > 3) {
      _refreshSubpage();
    }
    else {
      window.location.hash += '/${items.first.value}';
    }
  }
  
  @override
  void detached() {
    super.detached();
    
    this._hashChangeListener.cancel();
  }
  
  @observable List<ItemModel> get items => _items;
  void set items(List<ItemModel> items) {
    this.items
      ..clear()
      ..addAll(items);
  }
  
  void _refreshSubpage() {
    var hash = window.location.hash;
    this.subpage = hash.substring(hash.lastIndexOf('/') + 1);
  }
  
  void changeHash(CustomEvent event, var details, SelectButtonComponent target) {
    var selectedItems = target.selectedItems;
    
    if (selectedItems.length > 0) {
      var newSubpage = selectedItems.first.value;
      
      if (window.location.hash.endsWith(newSubpage)) {
        this.subpage = newSubpage;
      }
      else {
        window.location.hash = '${hashPrefix}/${newSubpage}';
      }
    }
    else {
      this.subpage = null;
    }
  }
  
}