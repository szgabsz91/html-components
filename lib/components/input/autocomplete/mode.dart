part of autocomplete;

class AutocompleteMode {
  final int _index;
  
  const AutocompleteMode(int this._index);
  
  static const CLIENT_STRING = const AutocompleteMode(0);
  static const CLIENT_OBJECT_TEMPLATE = const AutocompleteMode(1);
  static const CLIENT_OBJECT_NOTEMPLATE = const AutocompleteMode(2);
  static const SERVER_STRING = const AutocompleteMode(3);
  static const SERVER_OBJECT_TEMPLATE = const AutocompleteMode(4);
  static const SERVER_OBJECT_NOTEMPLATE = const AutocompleteMode(5);
  
  static const values = const [
    CLIENT_STRING,
    CLIENT_OBJECT_TEMPLATE,
    CLIENT_OBJECT_NOTEMPLATE,
    SERVER_STRING,
    SERVER_OBJECT_TEMPLATE,
    SERVER_OBJECT_NOTEMPLATE
  ];
  
  String toString() => "AutocompleteMode($_index)";
}