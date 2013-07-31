part of autocomplete;

bool _fitsCriteria(Object object, String property, String query) {
  String propertyValue = reflection.getPropertyValue(object, property).toString();
  return propertyValue.toLowerCase().startsWith(query.toLowerCase());
}