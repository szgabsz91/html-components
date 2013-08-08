library clock;

import "package:polymer/polymer.dart";
import "dart:html";
import "dart:svg";

part "clock/model.dart";

@CustomTag("h-clock")
class ClockComponent extends PolymerElement with ObservableMixin {
  ClockModel model = new ClockModel();
  
  ShadowRoot get _shadowRoot => getShadowRoot("h-clock");
  GElement get _hourHand => _shadowRoot.query("#hour");
  GElement get _minuteHand => _shadowRoot.query("#minute");
  GElement get _secondHand => _shadowRoot.query("#second");
  
  void inserted() {
    DateTime date = new DateTime.now();
    
    int h = date.hour;
    h = h > 12 ? h - 12: h;
    int m = date.minute;
    int s = date.second;
    
    int second = 6 * s;
    double minute = (m + s / 60) * 6;
    double hour = (h + m / 60 + s / 3600) * 30;
    
    _hourHand.attributes["transform"] = "rotate($hour)";
    _minuteHand.attributes["transform"] = "rotate($minute)";
    _secondHand.attributes["transform"] = "rotate($second)";
  }
  
  int get size => model.size;
  void set size(var size) {
    if (size is int) {
      model.size = size;
    }
    else if (size is String) {
      model.size = int.parse(size);
    }
    else {
      throw new ArgumentError("The size property must be of type int or String!");
    }
  }
}