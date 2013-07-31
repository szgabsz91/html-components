part of converters;

String mapToString(Map map) {
  StringBuffer buffer = new StringBuffer("{");
  
  map.keys.forEach((var key) {
    buffer.write('"${key.toString()}":"${map[key].toString()}",');
  });
  
  String result = buffer.toString();
  
  return result.substring(0, result.length - 1) + "}";
}