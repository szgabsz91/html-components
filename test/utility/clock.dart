library clock_tests;

import 'package:unittest/unittest.dart';
import 'package:polymer/polymer.dart';
import 'package:html_components/html_components.dart';
import 'dart:html';
import 'dart:async';

void main() {
  group('utility', () {
    group('clock', () {
      ClockComponent clock = null;
      Element svg = null;
      Element hour = null;
      Element minute = null;
      Element second = null;
      int size;
      
      tearDown(() {
        clock.remove();
      });
      
      group('with default attribute values', () {
        setUp(() {
          size = 270;
          
          clock = new Element.html('<h-clock></h-clock>', treeSanitizer: new NullTreeSanitizer());
          document.body.append(clock);
          
          svg = clock.shadowRoot.querySelector('svg');
          hour = clock.shadowRoot.querySelector('#hour');
          minute = clock.shadowRoot.querySelector('#minute');
          second = clock.shadowRoot.querySelector('#second');
        });
        
        test('check if SVG is present', () {
          expect(svg, isNotNull);
        });
        
        test('initial size property must be 270', () {
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
          
          int seconds = 6 * s;
          double minutes = (m + s / 60) * 6;
          double hours = (h + m / 60 + s / 3600) * 30;
          
          expect(hour.attributes['transform'], equals('rotate(${hours})'));
          expect(minute.attributes['transform'], equals('rotate(${minutes})'));
          expect(second.attributes['transform'], equals('rotate(${seconds})'));
        });
        
        test('changing the size property should resize the SVG', () {
          clock.setAttribute('size', '500');
          
          Observable.dirtyCheck();
          
          Timer.run(expectAsync0(() {
            expect(clock.size, equals(500));
            expect(svg.style.width, equals('500px'));
            expect(svg.style.height, equals('500px'));
          }));
        });
      });
      
      group('with custom attribute values', () {
        setUp(() {
          size = 500;
          
          clock = new Element.html('<h-clock size="${size}"></h-clock>', treeSanitizer: new NullTreeSanitizer());
          document.body.append(clock);
          
          svg = clock.shadowRoot.querySelector('svg');
          hour = clock.shadowRoot.querySelector('#hour');
          minute = clock.shadowRoot.querySelector('#minute');
          second = clock.shadowRoot.querySelector('#second');
        });
        
        test('the size of the SVG must match the size property', () {
          expect(clock.size, equals(size));
          expect(svg.style.width, equals('${size}px'));
          expect(svg.style.height, equals('${size}px'));
        });
      });
    });
  });
}