import 'package:html_components/html_components.dart' show SelectItemModel;

abstract class SelectItemConverter {
  
  String selectItemsToString(List<SelectItemModel> selectedItems) {
    if (selectedItems.isEmpty) {
      return 'none';
    }
    
    StringBuffer resultBuffer = new StringBuffer();
    
    for (SelectItemModel selectedItem in selectedItems) {
      resultBuffer.write('${selectedItem.label}, ');
    }
    
    String result = resultBuffer.toString();
    
    if (result.length > 0) {
      return result.substring(0, result.length - 2);
    }
    
    return result;
  }
  
}