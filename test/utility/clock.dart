library clock_tests;

import 'package:unittest/unittest.dart';
import 'package:html_components/utility/clock.dart';
import 'dart:html';

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(node) {}
}

void main() {
  group('utility', () {
    group('clock', () {
      ClockComponent clock = null;
      int size;
      
      group('with default attribute values', () {
        setUp(() {
          size = 270;
          
          clock = new Element.html('<h-clock></h-clock>', treeSanitizer: new NullTreeSanitizer());
          document.body.append(clock);
        });
        
        test('check if SVG is present', () {
          Element svg = clock.shadowRoot.querySelector('svg');
          
          expect(svg, isNotNull);
        });
        
        test('initial size property must be 270', () {
          Element svg = clock.shadowRoot.querySelector('svg');
          
          expect(clock.size, equals(size));
          expect(svg.style.width, equals('${size}px'));
          expect(svg.style.height, equals('${size}px'));
        });
        
        test('the clock should show the exact time', () {
          DateTime date = new DateTime.now();
          
          int h = date.hour;
          h = h > 12 ? h - 12: h;
          int m = date.minute;
          int s = date.second;
          
          int second = 6 * s;
          double minute = (m + s / 60) * 6;
          double hour = (h + m / 60 + s / 3600) * 30;
          
          Element hourElement = clock.shadowRoot.querySelector('#hour');
          Element minuteElement = clock.shadowRoot.querySelector('#minute');
          Element secondElement = clock.shadowRoot.querySelector('#second');
          
          expect(hourElement.attributes['transform'], equals('rotate(${hour})'));
          expect(minuteElement.attributes['transform'], equals('rotate(${minute})'));
          expect(secondElement.attributes['transform'], equals('rotate(${second})'));
        });
      });
      
      group('with custom attribute values', () {
        setUp(() {
          size = 500;
          
          clock = new Element.html('<h-clock size="${size}"></h-clock>', treeSanitizer: new NullTreeSanitizer());
          document.body.append(clock);
        });
        
        test('the size of the SVG must match the size property', () {
          Element svg = clock.shadowRoot.querySelector('svg');
          
          expect(clock.size, equals(size));
          expect(svg.style.width, equals('${size}px'));
          expect(svg.style.height, equals('${size}px'));
        });
      });
    });
  });
}