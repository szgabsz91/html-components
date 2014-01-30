library growl_message_tests;

import 'package:unittest/unittest.dart';
import 'package:html_components/html_components.dart';
import 'dart:html';
import 'dart:async';

void main() {
  group('utility', () {
    group('growl_message', () {
      GrowlMessageComponent growlMessage = null;
      final String SUMMARY = 'summary';
      final String DETAIL = 'detail';
      final String SEVERITY = 'warn';
      DivElement container = null;
      AnchorElement closethick = null;
      AnchorElement icon = null;
      SpanElement summary = null;
      SpanElement detail = null;
      
      tearDown(() {
        growlMessage.remove();
      });
      
      setUp(() {
        growlMessage = new Element.html(
            '<h-growl-message summary="${SUMMARY}" detail="${DETAIL}" severity="${SEVERITY}"></h-growl-message>',
            treeSanitizer: new NullTreeSanitizer()
        );
        document.body.append(growlMessage);
        
        container = growlMessage.shadowRoot.querySelector('#container');
        closethick = growlMessage.shadowRoot.querySelector('#close-thick');
        icon = growlMessage.shadowRoot.querySelector('#icon');
        summary = growlMessage.shadowRoot.querySelector('#summary');
        detail = growlMessage.shadowRoot.querySelector('#detail');
      });
      
      test('the given attributes should be set and displayed in the component', () {
        expect(growlMessage.summary, equals(SUMMARY));
        expect(growlMessage.detail, equals(DETAIL));
        expect(growlMessage.severity, equals(SEVERITY));
        
        expect(icon.className, equals(SEVERITY));
        expect(summary.text, equals(SUMMARY));
        expect(detail.text, equals(DETAIL));
      });
      
      test('the model getter should return the proper model object', () {
        GrowlMessageModel model = growlMessage.model;
        
        expect(model.summary, equals(SUMMARY));
        expect(model.detail, equals(DETAIL));
        expect(model.severity, equals(SEVERITY));
      });
      
      test('clicking the closethick should animate the message and close it than fire the closed event', () {
        growlMessage.onClosed.listen(expectAsync1((Event _) {
        }));
        
        closethick.click();
        
        expect(container.style.opacity, equals('0'));
        expect(container.style.margin, equals('0px'));
        expect(container.style.padding, equals('0px'));
        
        new Timer(const Duration(milliseconds: 500), expectAsync0(() {
          expect(container.style.height, equals('0px'));
        }));
      });
    });
  });
}