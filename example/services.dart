import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:html_components/common/reflection.dart' as reflection;

class Player {
  String name;
  int number;
  
  Player(String this.name, int this.number);
  
  String get imagePath => "${name.toLowerCase()}.jpg";
  
  String toString() => "Player[name=$name, number=$number, imagePath=$imagePath]";
  
  Map<String, Object> toJson() {
    return {'name': name, 'number': number, 'imagePath': imagePath};
  }
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

class Car {
  String model;
  String manufacturer;
  int year;
  bool warranty;
  
  Car(String this.model, String this.manufacturer, int this.year, bool this.warranty);
  
  String get imagePath => "${manufacturer}.jpg";
  
  String toString() => model;
  
  Map<String, Object> toJson() {
    return {'model': model, 'manufacturer': manufacturer, 'year': year, 'warranty': warranty, 'imagePath': imagePath};
  }
}

class TreeNode {
  String data;
  bool isParent;
  
  TreeNode(this.data, [this.isParent = true]);
  
  Map<String, Object> toJson() => {'data': data, 'isParent': isParent};
}

Map<String, List<String>> stringTreeNodes = {
  null: [new TreeNode('Node 0'), new TreeNode('Node 1'), new TreeNode('Node 2', false)],
  'Node 0': [new TreeNode('Node 0.0'), new TreeNode('Node 0.1')],
  'Node 1': [new TreeNode('Node 1.0'), new TreeNode('Node 1.1', false)],
  'Node 2': [],
  'Node 0.0': [new TreeNode('Node 0.0.0', false), new TreeNode('Node 0.0.1', false)],
  'Node 0.1': [new TreeNode('Node 0.1.0', false)],
  'Node 1.0': [new TreeNode('Node 1.0.0', false)],
  'Node 1.1': [],
  'Node 0.0.0': [],
  'Node 0.0.1': [],
  'Node 0.1.0': [],
  'Node 1.0.0': []
};

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

class Document {
  String name;
  String size;
  String type;
  
  Document(String this.name, String this.size, String this.type);
  
  Map<String, Object> toJson() => {'name': name, 'size': size, 'type': type};
  
  String toString() => name;
}

class DocumentTreeNode {
  Document data;
  bool isParent;
  
  DocumentTreeNode(this.data, [this.isParent = true]);
  
  Map<String, Object> toJson() => {'data': data, 'isParent': isParent};
}

Map<String, List<DocumentTreeNode>> documentTreeNodes = {
  null: [new DocumentTreeNode(new Document("Documents", "80 KB", "Folder")), new DocumentTreeNode(new Document("Pictures", "171 KB", "Folder")), new DocumentTreeNode(new Document("Movies", "79 GB", "Folder"))],
  'Documents': [new DocumentTreeNode(new Document("Work", "40 KB", "Folder")), new DocumentTreeNode(new Document("HTML Components", "3 MB", "Folder"))],
  'Pictures': [new DocumentTreeNode(new Document("barcelona.jpg", "30 KB", "JPEG Image"), false), new DocumentTreeNode(new Document("logo.jpg", "45 KB", "JPEG Image"), false), new DocumentTreeNode(new Document("honda.png", "96 KB", "PNG Image"), false)],
  'Movies': [new DocumentTreeNode(new Document("Al Pacino", "39 GB", "Folder")), new DocumentTreeNode(new Document("Robert De Niro", "40 GB", "Folder"))],
  'Work': [new DocumentTreeNode(new Document("Expenses.doc", "30 KB", "Word Document"), false), new DocumentTreeNode(new Document("Resume.doc", "10 KB", "Word Document"), false)],
  'HTML Components': [new DocumentTreeNode(new Document("Documentation.pdf", "3 MB", "PDF Document"), false)],
  'barcelona.jpg': [],
  'logo.jpg': [],
  'honda.png': [],
  'Al Pacino': [new DocumentTreeNode(new Document("Scarface", "15 GB", "Movie File"), false), new DocumentTreeNode(new Document("Carlitos' Way", "24 GB", "Movie File"), false)],
  'Robert De Niro': [new DocumentTreeNode(new Document("Goodfellas", "23 GB", "Movie File"), false), new DocumentTreeNode(new Document("Untouchables", "17 GB", "Movie File"), false)],
  'Expenses.doc': [],
  'Resume.doc': [],
  'Documentation.pdf': [],
  'Scarface': [],
  'Carlitos\' Way': [],
  'Goodfellas': [],
  'Untouchables': []
};

void main() {
  HttpServer.bind("localhost", 9090).then((HttpServer server) {
    server.listen((HttpRequest request) {
      HttpResponse response = request.response;
      response.headers
        ..add('Access-Control-Allow-Origin', '*')
        ..add('Access-Control-Allow-Methods', 'POST, GET, PUT, OPTIONS')
        ..add('Access-Control-Max-Age', '1000')
        ..add('Access-Control-Allow-Headers', '*');
      
      _serve(request).then((_) {
        request.response.close();
      });
    });
  });
}

Future _serve(HttpRequest request) {
  Completer completer = new Completer();
  
  String url = request.uri.toString();
  HttpResponse response = request.response;
  
  if (url.startsWith('/autocomplete/string')) {
    _autocompleteString(response, url.substring(url.lastIndexOf('?') + 1));
    completer.complete();
  }
  else if (url.startsWith('/autocomplete/object')) {
    _autocompleteObject(response, url.substring(url.lastIndexOf('?') + 1));
    completer.complete();
  }
  else if (url.startsWith('/carousel/cars')) {
    _carouselCars(response, url.substring(url.lastIndexOf('/') + 1));
    completer.complete();
  }
  else if (url.startsWith('/datagrid/cars')) {
    _datagridCars(response, url.substring(url.lastIndexOf('?') + 1));
    completer.complete();
  }
  else if (url.startsWith('/tree/string')) {
    List<int> dataBody = new List<int>();
    request.listen(dataBody.addAll, onDone: () {
      String data = new String.fromCharCodes(dataBody);
      _treeString(response, data);
      completer.complete();
    });
  }
  else if (url.startsWith('/datatable/cars')) {
    _datagridCars(response, url.substring(url.lastIndexOf('?') +1));
    completer.complete();
  }
  else if (url.startsWith('')) {
    List<int> dataBody = new List<int>();
    request.listen(dataBody.addAll, onDone: () {
      String data = new String.fromCharCodes(dataBody);
      _treetableDocument(response, data);
      completer.complete();
    });
  }
  else {
    response.statusCode = HttpStatus.NOT_FOUND;
    completer.complete();
  }
  
  return completer.future;
}

void _autocompleteString(HttpResponse response, String queryParams) {
  String q = queryParams.split('=')[1];
  
  List<Player> result =
    players
      .where((Player player) => player.name.toLowerCase().startsWith(q.toLowerCase()))
      .map((Player player) => player.name)
      .toList(growable: false);
  
  String json = JSON.encode(result);
  
  response.write(json);
}

void _autocompleteObject(HttpResponse response, String queryParams) {
  String q = queryParams.split('&')[0].split('=')[1];
  String property = queryParams.split('&')[1].split('=')[1];
  
  List<Player> result =
    players
      .where((Player player) => reflection.getPropertyValue(player, property).toString().toLowerCase().startsWith(q.toLowerCase()))
      .toList(growable: false);
  
  String json = JSON.encode(result);
  
  response.write(json);
}

void _carouselCars(HttpResponse response, String param) {
  int count = int.parse(param);
  
  List<Car> result =
    cars
      .take(count)
      .toList(growable: false);
  
  String json = JSON.encode(result);
  
  response.write(json);
}

void _datagridCars(HttpResponse response, String queryParams) {
  int page = int.parse(queryParams.split('&')[0].split('=')[1]);
  int rows = int.parse(queryParams.split('&')[1].split('=')[1]);
  
  List<Car> result =
    cars
      .skip((page - 1) * rows)
      .take(rows)
      .toList(growable: false);
  
  Map<String, Object> responseObject = {
    'totalCount': cars.length,
    'result': result
  };
  
  String json = JSON.encode(responseObject);
  
  response.write(json);
}

_treeString(HttpResponse response, String data) {
  if (data == 'null') {
    response.write(JSON.encode(stringTreeNodes[null]));
    return;
  }
  
  Map<String, Object> parent = JSON.decode(data);
  
  response.write(JSON.encode(stringTreeNodes[parent['data']]));
}

void _treetableDocument(HttpResponse response, String data) {
  if (data == 'null') {
    response.write(JSON.encode(documentTreeNodes[null]));
    return;
  }
  
  String parentName = JSON.decode(data)['data']['name'];
  
  response.write(JSON.encode(documentTreeNodes[parentName]));
}