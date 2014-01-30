library notification_bar_tests;

import 'package:unittest/unittest.dart';
import 'package:html_components/html_components.dart';
import 'dart:html';
import 'dart:async';

void main() {
  group('utility', () {
    group('notification-bar', () {
      NotificationBarComponent notificationBar = null;
      DivElement container = null;
      ContentElement content = null;
      HeadingElement heading = null;
      
      setUp(() {
        notificationBar = new Element.html('<h-notification-bar><h3>Message</h3></h-notificationBar>', treeSanitizer: new NullTreeSanitizer());
        document.body.append(notificationBar);
        
        container = notificationBar.shadowRoot.querySelector('#container');
        content = notificationBar.shadowRoot.querySelector('#container content');
        heading = content.getDistributedNodes()[0];
      });
      
      tearDown(() {
        notificationBar.remove();
      });
      
      test('the given child elements must be present inside the container', () {
        expect(heading, isNotNull);
        expect(heading.text, equals('Message'));
      });
      
      test('show and hide should animate the container', () {
        expect(container.style.height, equals('0px'));
        expect(notificationBar.visible, isFalse);
        
        notificationBar.show();
        
        new Timer(const Duration(milliseconds: 500), expectAsync0(() {
          expect(container.style.height, '${notificationBar.contentHeight}px');
          expect(notificationBar.visible, isTrue);
          
          notificationBar.hide();
          
          new Timer(const Duration(milliseconds: 500), expectAsync0(() {
            expect(container.style.height, '0px');
            expect(notificationBar.visible, isFalse);
          }));
        }));
      });
    });
  });
}