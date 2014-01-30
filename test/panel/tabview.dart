library tabview_tests;

import 'package:unittest/unittest.dart';
import 'package:html_components/html_components.dart';
import 'dart:html';
import 'dart:async';

void main() {
  group('panel', () {
    group('tabview', () {
      TabviewComponent tabview = null;
      List<TabModel> tabs = [
        new TabModel('Tab 1', false, false, false, false, 'Tab 1 Content'),
        new TabModel('Tab 2', true, false, true, false, 'Tab 2 Content'),
        new TabModel('Tab 3', false, true, false, false, 'Tab 2 Content'),
      ];
      
      setUp(() {
        tabview = new Element.html(
            '''
            <h-tabview>
              <h-tab header="${tabs[0].header}" content="${tabs[0].content}"></h-tab>
              <h-tab header="${tabs[1].header}" content="${tabs[1].content}" selected="${tabs[1].selected}" closable="${tabs[1].closable}"></h-tab>
              <h-tab header="${tabs[2].header}" content="${tabs[2].content}" disabled="${tabs[2].disabled}"></h-tab>
            </h-tabview>
            ''',
            treeSanitizer: new NullTreeSanitizer()
        );
        document.body.append(tabview);
      });
      
      test('tabs should be processed, hidden area should be removed', () {
        scheduleMicrotask(expectAsync0(() {
          for (int i = 0; i < tabs.length; i++) {
            expect(tabview.tabs[i], equals(tabs[i]));
          }
          
          DivElement hidden = tabview.shadowRoot.querySelector('hidden');
          expect(hidden, isNull);
        }));
      });
      
      test('tabs should be processed, hidden area should be removed, first tab should be selected if no tab is selected', () {
        tabs = [
          new TabModel('Tab 1', false, false, false, false, 'Tab 1 Content'),
          new TabModel('Tab 2', false, false, true, false, 'Tab 2 Content'),
          new TabModel('Tab 3', false, true, false, false, 'Tab 2 Content'),
        ];
        tabview.remove();
        tabview = new Element.html(
            '''
            <h-tabview>
              <h-tab header="${tabs[0].header}" content="${tabs[0].content}"></h-tab>
              <h-tab header="${tabs[1].header}" content="${tabs[1].content}" selected="${tabs[1].selected}" closable="${tabs[1].closable}"></h-tab>
              <h-tab header="${tabs[2].header}" content="${tabs[2].content}" disabled="${tabs[2].disabled}"></h-tab>
            </h-tabview>
            ''',
            treeSanitizer: new NullTreeSanitizer()
        );
        document.body.append(tabview);
        
        scheduleMicrotask(expectAsync0(() {
          tabs[0].selected = true;
          
          for (int i = 0; i < tabs.length; i++) {
            expect(tabview.tabs[i], equals(tabs[i]));
          }
          
          DivElement hidden = tabview.shadowRoot.querySelector('hidden');
          expect(hidden, isNull);
        }));
      });
    });
  });
}