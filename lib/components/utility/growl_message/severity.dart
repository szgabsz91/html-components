part of growl_message;

class GrowlMessageSeverity {
  final int _index;
  
  const GrowlMessageSeverity(int this._index);
  
  factory GrowlMessageSeverity.fromString(final String severity) {
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
  
  static const INFO = const GrowlMessageSeverity(0);
  static const WARN = const GrowlMessageSeverity(1);
  static const ERROR = const GrowlMessageSeverity(2);
  static const FATAL = const GrowlMessageSeverity(3);
  
  static const values = const [
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