import 'package:html_components/html_components.dart';

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

////////////////////////////////////////////////////////////////////////////////

class Car {
  String model;
  String manufacturer;
  int year;
  bool warranty;
  
  Car(String this.model, String this.manufacturer, int this.year, bool this.warranty);
  
  String get imagePath => "${manufacturer}.jpg";
  
  String toString() => model;
}

List<Car> cars = [
  new Car("107f6514", "Honda", 2012, true),
  new Car("4c182d41", "Audi", 1965, false),
  new Car("b32ff478", "Chrysler", 1990, true),
  new Car("9a657f4d", "Ferrari", 2005, false),
  new Car("e79e04ac", "Opel", 2002, false),
  new Car("c26b4bdd", "Mercedes", 1968, true),
  new Car("0f7c6bf8", "Mercedes", 2005, false),
  new Car("2e18d596", "Honda", 1988, false),
  new Car("55f8ae33", "Opel", 1985, false),
  new Car("ead885f7", "Volkswagen", 2005, false),
  new Car("b4d60a09", "BMW", 1995, false),
  new Car("bf503dea", "Opel", 2006, false),
  new Car("09edd664", "Volvo", 1976, false),
  new Car("004dfda3", "Chrysler", 1999, false),
  new Car("48dccaa5", "Mercedes", 1983, true),
  new Car("a2d920ab", "Audi", 1971, true),
  new Car("e392f591", "Mercedes", 2005, false),
  new Car("9585cac1", "Mercedes", 2008, true),
  new Car("13e9e1bf", "Honda", 1990, true),
  new Car("ef4e526a", "Ferrari", 1972, false),
  new Car("439f21a7", "BMW", 1996, false),
  new Car("19924a3b", "Ferrari", 1990, true),
  new Car("c371ca0d", "Opel", 1996, false),
  new Car("3a5f1d0b", "BMW", 1973, true),
  new Car("7b966c83", "Volkswagen", 2008, false),
  new Car("76ca3f21", "Opel", 1983, true),
  new Car("0865717f", "Honda", 1972, false),
  new Car("ae7a37f5", "Ferrari", 1976, false),
  new Car("dfe81f5a", "Opel", 1991, true),
  new Car("8e001e99", "Volvo", 1976, false),
  new Car("edfecf6d", "Opel", 1975, false),
  new Car("1968e984", "Honda", 1989, false),
  new Car("cae24651", "BMW", 1974, false),
  new Car("b9fe01bb", "Renault", 2001, true),
  new Car("b45964f6", "Renault", 2005, true),
  new Car("039040ee", "Volkswagen", 1976, true),
  new Car("395a1c95", "Chrysler", 2003, false),
  new Car("71d3e760", "Chrysler", 2003, true),
  new Car("ff12cf33", "BMW", 1983, true),
  new Car("e6590710", "Ferrari", 2009, true),
  new Car("27da1304", "Honda", 1987, true),
  new Car("bff9afd9", "Volvo", 1976, true),
  new Car("a77b396f", "Mercedes", 1971, false),
  new Car("e51d6ab0", "Ferrari", 1961, true),
  new Car("dd9dc756", "Volkswagen", 2003, false),
  new Car("b46bd077", "Chrysler", 1963, false),
  new Car("92aa8974", "Renault", 1991, true),
  new Car("ba8d99b6", "Volvo", 2003, true),
  new Car("193808e9", "Volvo", 1967, true),
  new Car("5ab07802", "Chrysler", 1975, true)
];

////////////////////////////////////////////////////////////////////////////////

class Document {
  String name;
  String size;
  String type;
  
  Document(String this.name, String this.size, String this.type);
  
  String toString() => name;
}

TreeNode getDocumentRoot() {
  TreeNode documentRoot = new TreeNode();
  
  TreeNode documents = new TreeNode(new Document("Documents", "80 KB", "Folder"), documentRoot);
  TreeNode pictures = new TreeNode(new Document("Pictures", "171 KB", "Folder"), documentRoot);
  TreeNode movies = new TreeNode(new Document("Movies", "79 GB", "Folder"), documentRoot);
  TreeNode work = new TreeNode(new Document("Work", "40 KB", "Folder"), documents);
  TreeNode htmlComponents = new TreeNode(new Document("HTML Components", "3 MB", "Folder"), documents);
  
  //Documents
  TreeNode expenses = new TreeNode(new Document("Expenses.doc", "30 KB", "Word Document"), work, "document");
  TreeNode resume = new TreeNode(new Document("Resume.doc", "10 KB", "Word Document"), work, "document");
  TreeNode documentation = new TreeNode(new Document("Documentation.pdf", "3 MB", "PDF Document"), htmlComponents, "document");
  
  //Pictures
  TreeNode barca = new TreeNode(new Document("barcelona.jpg", "30 KB", "JPEG Image"), pictures, "picture");
  TreeNode logo = new TreeNode(new Document("logo.jpg", "45 KB", "JPEG Image"), pictures, "picture");
  TreeNode honda = new TreeNode(new Document("honda.png", "96 KB", "PNG Image"), pictures, "picture");
  
  //Movies
  TreeNode pacino = new TreeNode(new Document("Al Pacino", "39 GB", "Folder"), movies);
  TreeNode deniro = new TreeNode(new Document("Robert De Niro", "40 GB", "Folder"), movies);
  TreeNode scarface = new TreeNode(new Document("Scarface", "15 GB", "Movie File"), pacino, "movie");
  TreeNode carlitosWay = new TreeNode(new Document("Carlitos' Way", "24 GB", "Movie File"), pacino, "movie");
  TreeNode goodfellas = new TreeNode(new Document("Goodfellas", "23 GB", "Movie File"), deniro, "movie");
  TreeNode untouchables = new TreeNode(new Document("Untouchables", "17 GB", "Movie File"), deniro, "movie");
  
  return documentRoot;
}

TreeNode getStringRoot() {
  TreeNode stringRoot = new TreeNode();
  
  StringTreeNode node0 = new StringTreeNode("Node 0", stringRoot);
  StringTreeNode node1 = new StringTreeNode("Node 1", stringRoot);
  StringTreeNode node2 = new StringTreeNode("Node 2", stringRoot);
  
  StringTreeNode node00 = new StringTreeNode("Node 0.0", node0);
  StringTreeNode node01 = new StringTreeNode("Node 0.1", node0);
  
  StringTreeNode node10 = new StringTreeNode("Node 1.0", node1);
  StringTreeNode node11 = new StringTreeNode("Node 1.1", node1);
  
  StringTreeNode node000 = new StringTreeNode("Node 0.0.0", node00);
  StringTreeNode node001 = new StringTreeNode("Node 0.0.1", node00);
  
  StringTreeNode node010 = new StringTreeNode("Node 0.1.0", node01);
  
  StringTreeNode node100 = new StringTreeNode("Node 1.0.0", node10);
  
  return stringRoot;
}