import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

class Player {
  String name;
  int number;
  
  Player(String this.name, int this.number);
  
  String get imagePath => '${name.toLowerCase()}.jpg';
  
  String toString() => 'Player[name=$name, number=$number, imagePath=$imagePath]';
}

List<Player> _players = [
  new Player('Messi', 10),
  new Player('Bojan', 9),
  new Player('Iniesta', 8),
  new Player('Villa', 7),
  new Player('Xavi', 6),
  new Player('Puyol', 5),
  new Player('Afellay', 20),
  new Player('Abidal', 22),
  new Player('Alves', 2),
  new Player('Pique', 3),
  new Player('Keita', 15),
  new Player('Adriano', 21),
  new Player('Valdes', 1)
];

List<String> get _playerNames => _players.map((Player player) => player.name).toList(growable: false);

@CustomTag('listbox-demo')
class ListboxDemo extends PolymerElement {
  
  @observable List<Player> players = toObservable(_players);
  @observable List<String> playerNames = toObservable(_playerNames);
  
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