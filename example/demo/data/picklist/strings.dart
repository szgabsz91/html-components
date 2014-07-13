import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show PicklistComponent, GrowlComponent;
import '../../../data/player.dart' as data;

@CustomTag('picklist-strings-demo')
class PicklistStringsDemo extends ShowcaseItem with data.PlayerConverter {
  
  @observable List<String> players = toObservable(data.playerNames);
  @observable String selection = 'single';
  @observable bool order = true;
  
  PicklistStringsDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/picklist/strings.html', 'demo/data/picklist/strings.dart', 'data/player.dart']);
  }
  
  void onPicked(Event event, var detail, PicklistComponent target) {
    GrowlComponent.postMessage('Picked items:', playersToString(target.pickedItems));
  }
  
}