import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show ListboxComponent, GrowlComponent;
import '../../../data/player.dart' as data;

@CustomTag('listbox-strings-demo')
class ListboxStringsDemo extends ShowcaseItem with data.PlayerConverter {
  
  @observable List<String> players = toObservable(data.playerNames);
  @observable String selection = 'single';
  @observable String sidebar = 'left';
  
  ListboxStringsDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/listbox/strings.html', 'demo/data/listbox/strings.dart', 'data/player.dart']);
  }
  
  void onItemSelected(Event event, var detail, ListboxComponent target) {
    GrowlComponent.postMessage('Selected items:', playersToString(target.selectedItems));
  }
  
  void onReordered(Event event, var detail, ListboxComponent target) {
    GrowlComponent.postMessage('Reordered items:', playersToString(target.data));
  }
  
}