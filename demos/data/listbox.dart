import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import '../../data/test_data.dart' as data;

@CustomTag('listbox-demo')
class ListboxDemo extends PolymerElement {
  
  @observable List<data.Player> players = toObservable(data.players);
  @observable List<String> playerNames = toObservable(data.playerNames);
  
  bool get applyAuthorStyles => true;
  
  ListboxDemo.created() : super.created();
  
  void onItemSelected(Event event, var detail, Element target) {
    GrowlComponent.postMessage('Selected items:', itemsToString(target.selectedItems));
  }
  
  void onReordered(Event event, var detail, Element target) {
    GrowlComponent.postMessage('Reordered items:', itemsToString(target.data));
  }
  
  String itemsToString(var selectedItems) {
    if (selectedItems.isEmpty) {
      return 'none';
    }
    
    StringBuffer resultBuffer = new StringBuffer();
    
    // Exception: type 'SelectItemModel' is not a subtype of type 'SelectItemModel' of 'selectedItem'.
    for (var selectedItem in selectedItems) {
      if (selectedItem is String) {
        resultBuffer.write('${selectedItem}, ');
      }
      else {
        resultBuffer.write('${selectedItem.name}, ');
      }
    }
    
    String result = resultBuffer.toString();
    
    if (result.length > 0) {
      return result.substring(0, result.length - 2);
    }
    
    return result;
  }
  
}