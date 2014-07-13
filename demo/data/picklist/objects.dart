import 'package:polymer/polymer.dart';
import '../../showcase/item.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show PicklistComponent, GrowlComponent;
import '../../../data/player.dart' as data;

@CustomTag('picklist-objects-demo')
class PicklistObjectsDemo extends ShowcaseItem with data.PlayerConverter {
  
  @observable List<data.Player> players = toObservable(data.players);
  @observable String selection = 'single';
  @observable bool order = true;
  
  PicklistObjectsDemo.created() : super.created() {
    super.setCodeSamples(const ['demo/data/picklist/objects.html', 'demo/data/picklist/objects.dart', 'data/player.dart']);
  }
  
  void onPicked(Event event, var detail, PicklistComponent target) {
    GrowlComponent.postMessage('Picked items:', playersToString(target.pickedItems));
  }
  
}