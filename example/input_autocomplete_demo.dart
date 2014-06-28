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

@CustomTag('autocomplete-demo')
class AutocompleteDemo extends PolymerElement {
  
  @observable List<Player> players = toObservable(_players);
  @observable List<String> playerNames = toObservable(_playerNames);
  
  AutocompleteDemo.created() : super.created();
  
  void onValueChangedFired(Event event, var detail, AutocompleteComponent target) {
    GrowlComponent.postMessage('Value changed:', target.value);
  }
  
}