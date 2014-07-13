class Player {
  String name;
  int number;
  
  Player(String this.name, int this.number);
  
  String get imagePath => '${name.toLowerCase()}.jpg';
  
  String toString() => 'Player[name=$name, number=$number, imagePath=$imagePath]';
}

List<Player> players = [
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

List<String> get playerNames => players.map((Player player) => player.name).toList(growable: false);

abstract class PlayerConverter {
  
  String playersToString(List players) {
    if (players.isEmpty) {
      return 'none';
    }
    
    StringBuffer resultBuffer = new StringBuffer();
    
    for (var player in players) {
      if (player is String) {
        resultBuffer.write('${player}, ');
      }
      else if (player is Player) {
        resultBuffer.write('${player.name}, ');
      }
    }
    
    String result = resultBuffer.toString();
    
    if (result.length > 0) {
      return result.substring(0, result.length - 2);
    }
    
    return result;
  }
  
}