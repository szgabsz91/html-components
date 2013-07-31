part of datatable;

class ClientCellEditor {
  ColumnModel _column;
  Object _item;
  Object _oldValue;
  
  ColumnModel get column => _column;
  Object get item => _item;
  Object get oldValue => _oldValue;
  
  void startEditing(ColumnModel column, Object item) {
    if (_column != null) {
      cancelEditing();
    }
    
    _column = column;
    _column.editing = true;
    _item = item;
    _oldValue = reflection.getPropertyValue(_item, _column.property);
  }
  
  void cancelEditing() {
    _column.editing = false;
    reflection.setPropertyValue(_item, _column.property, _oldValue);
    _column = null;
    _item = null;
    _oldValue = null;
  }
  
  void acceptEditing(Object newValue) {
    _column.editing = false;
    reflection.setPropertyValue(_item, _column.property, newValue);
    _column = null;
    _item = null;
    _oldValue = null;
  }
}

class ServerCellEditor extends ClientCellEditor {
  Uri _serviceURL;
  
  ServerCellEditor(Uri this._serviceURL);
  
  void acceptEditing(Object newValue) {
    _column.editing = false;
    reflection.setPropertyValue(_item, _column.property, newValue);
    
    HttpRequest request = new HttpRequest();
    request.open("PUT", _serviceURL.toString(), async: false);
    request.send(json.stringify(_item));
    
    _column = null;
    _item = null;
    _oldValue = null;
  }
}