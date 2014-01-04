import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart';

class Player {
  String name;
  int number;
  
  Player(String this.name, int this.number);
  
  String get imagePath => "${name.toLowerCase()}.jpg";
  
  String toString() => "Player[name=$name, number=$number, imagePath=$imagePath]";
}

@CustomTag('picklist-page')
class PicklistPage extends PolymerElement {
  
  @observable List<Player> players = toObservable([
    new Player("Messi", 10),
    new Player("Bojan", 9),
    new Player("Iniesta", 8),
    new Player("Villa", 7),
    new Player("Xavi", 6),
    new Player("Puyol", 5),
    new Player("Afellay", 20),
    new Player("Abidal", 22),
    new Player("Alves", 2),
    new Player("Pique", 3),
    new Player("Keita", 15),
    new Player("Adriano", 21),
    new Player("Valdes", 1)
  ]);
  
  @observable List<Player> playerNames = toObservable([
    "Messi",
    "Bojan",
    "Iniesta",
    "Villa",
    "Xavi",
    "Puyol",
    "Afellay",
    "Abidal",
    "Alves",
    "Pique",
    "Keita",
    "Adriano",
    "Valdes"
   ]);
  
  PicklistPage.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    this.shadowRoot.querySelectorAll('h-picklist').forEach((PicklistComponent picklist) {
      picklist.on['picked'].listen((Event event) {
        print('picked: ${picklist.pickedItems}');
      });
    });
  }
  
}

void main() {
  initPolymer();
}