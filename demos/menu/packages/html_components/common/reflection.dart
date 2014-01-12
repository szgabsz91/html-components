import 'dart:mirrors';

Object getPropertyValue(Object object, String property) {
  if (object is Map) {
    return object[property];
  }
  else {
    InstanceMirror mirror = reflect(object);
    InstanceMirror field = mirror.getField(new Symbol(property));
    return field.reflectee;
  }
}

setPropertyValue(Object object, String property, Object value) {
  if (object is Map) {
    object[property] = value;
  }
  else {
    InstanceMirror mirror = reflect(object);
    InstanceMirror field = mirror.getField(new Symbol(property));
    
    if (value is String) {
      switch (field.type.simpleName.toString()) {
        case 'Symbol("String")':
          break;
          
        case 'Symbol("int")':
          value = int.parse(value);
          break;
          
        case 'Symbol("double")':
          value = double.parse(value);
          break;
          
        case 'Symbol("bool")':
          value = value.toString() == "true";
          break;
      }
    }
    
    mirror.setField(new Symbol(property), value);
  }
}