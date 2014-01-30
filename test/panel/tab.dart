library tab_tests;

import 'package:unittest/unittest.dart';
import 'package:html_components/html_components.dart';
import 'dart:html';

void main() {
  group('panel', () {
    group('tab', () {
      TabComponent tab = null;
      TabModel tabModel = null;
      
      setUp(() {
        tabModel = new TabModel('Header', true, true, true, true, '<p>Content</p>');
        
        tab = new Element.html(
            '<h-tab header="${tabModel.header}" selected="${tabModel.selected}" disabled="${tabModel.disabled}" closable="${tabModel.closable}" closed="${tabModel.closed}">${tabModel.content}</h-tab>',
            treeSanitizer: new NullTreeSanitizer()
        );
        document.body.append(tab);
      });
      
      tearDown(() {
        tab.remove();
      });
      
      test('attributes should be initialized, child elements should appear in content, hidden area should be removed', () {
        expect(tab.header, equals(tabModel.header));
        expect(tab.selected, equals(tabModel.selected));
        expect(tab.disabled, equals(tabModel.disabled));
        expect(tab.closable, equals(tabModel.closable));
        expect(tab.closed, equals(tabModel.closed));
        expect(tab.content, equals(tabModel.content));
        
        DivElement hidden = tab.shadowRoot.querySelector('#hidden');
        expect(hidden, isNull);
      });
    });
  });
}