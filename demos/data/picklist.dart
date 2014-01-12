import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';
import '../../data/test_data.dart' as data;

@CustomTag('picklist-demo')
class PicklistDemo extends PolymerElement {
  
  @observable List<data.Player> players = toObservable(data.players);
  @observable List<String> playerNames = toObservable(data.playerNames);
  
  bool get applyAuthorStyles => true;
  
  PicklistDemo.created() : super.created();
  
  void onPicked(Event event, var detail, Element target) {
    GrowlComponent.postMessage('Picked items:', itemsToString(target.pickedItems));
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