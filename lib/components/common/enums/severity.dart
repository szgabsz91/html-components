part of enums;

class Severity {
  final int _index;
  
  const Severity(int this._index);
  
  factory Severity.fromString(final String severity) {
    switch (severity) {
      case "info":
        return INFO;
      
      case "warn":
        return WARN;
      
      case "error":
        return ERROR;
      
      case "fatal":
        return FATAL;
      
      default:
        throw new ArgumentError("Unknow severity: $severity");
    }
  }
  
  static const Severity INFO = const Severity(0);
  static const Severity WARN = const Severity(1);
  static const Severity ERROR = const Severity(2);
  static const Severity FATAL = const Severity(3);
  
  static const List<Severity> values = const [
    INFO,
    WARN,
    ERROR,
    FATAL
  ];
  
  String toString() {
    switch (_index) {
      case 0:
        return "info";
      
      case 1:
        return "warn";
      
      case 2:
        return "error";
      
      case 3:
        return "fatal";
      
      default:
        return "unknown";
    }
  }
}