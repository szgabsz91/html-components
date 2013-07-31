library clock;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:svg";
import "dart:async";

part "clock/model.dart";

class ClockComponent extends WebComponent {
  
  ClockModel model = new ClockModel();
  
  DivElement get _container => this.query("#container");
  SvgElement _clock;
  GElement get _hourHand => _clock.query("#hour");
  GElement get _minuteHand => _clock.query("#minute");
  GElement get _secondHand => _clock.query("#second");
  
  void inserted() {
    // TODO Replace into HTML if SVG is supported
    _clock = new SvgElement.svg("""
      <svg xmlns="http://www.w3.org/2000/svg"
           viewBox="0 0 270 270">
        <g transform="translate(150,150)">
          <g>
            <circle r="108"  fill="none" stroke-width="4" stroke="gray"/>
            <circle r="97" fill="none" stroke-width="11" stroke="black" stroke-dasharray="4,46.789082" transform="rotate(-1.5)"/>
            <circle r="100" fill="none" stroke-width="5" stroke="black" stroke-dasharray="2,8.471976" transform="rotate(-.873)"/>
          </g>
          <g id="hands" transform="rotate(180)">
            <g id="hour">
              <line stroke-width="5" y2="75" stroke-linecap="round" stroke="blue" opacity=".5"/>
              <animateTransform attributeName="transform" type="rotate" repeatCount="indefinite" dur="12h" by="360"/>
              <circle r="7"/>
            </g>
            <g id="minute">
              <line stroke-width="4" y2="93" stroke-linecap="round" stroke="green" opacity=".9"/>
              <animateTransform attributeName="transform" type="rotate" repeatCount="indefinite" dur="60min" by="360"/>
              <circle r="6" fill="red"/>
            </g>
            <g id="second">
              <line stroke-width="2" y1="-20" y2="102" stroke-linecap="round" stroke="red"/>
              <animateTransform attributeName="transform" type="rotate" repeatCount="indefinite" dur="60s" by="360"/>
              <circle r="4" fill="blue"/>
            </g>
          </g>
        </g>
      </svg>
    """);
    
    _container.children.add(_clock);
    
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
  set size(var size) {
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