part of autocomplete;

@observable
class AutocompleteModel {
  int maxResults = 0;
  int delay = 1000;
  String property;
  var data;
  ObservableList<Object> suggestions = new ObservableList();
  String value = "";
  AutocompleteDataFetcher _dataFetcher;
  TemplateManager _templateManager;
  
  AutocompleteMode get _mode {
    if (property == null && _dataFetcher is AutocompleteClientDataFetcher) {
      return AutocompleteMode.CLIENT_STRING;
    }
    else if (property == null && _dataFetcher is AutocompleteServerDataFetcher) {
      return AutocompleteMode.SERVER_STRING;
    }
    else if (property != null && _dataFetcher is AutocompleteClientObjectDataFetcher && _templateManager != null) {
      return AutocompleteMode.CLIENT_OBJECT_TEMPLATE;
    }
    else if (property != null && _dataFetcher is AutocompleteClientObjectDataFetcher && _templateManager == null) {
      return AutocompleteMode.CLIENT_OBJECT_NOTEMPLATE;
    }
    else if (property != null && _dataFetcher is AutocompleteServerObjectDataFetcher && _templateManager != null) {
      return AutocompleteMode.SERVER_OBJECT_TEMPLATE;
    }
    else if (property != null && _dataFetcher is AutocompleteServerObjectDataFetcher && _templateManager == null) {
      return AutocompleteMode.SERVER_OBJECT_NOTEMPLATE;
    }
    else {
      throw new UnsupportedError("Unsupported autocomplete mode!");
    }
  }
}