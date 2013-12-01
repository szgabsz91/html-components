library notification_bar_tests;

import 'package:unittest/unittest.dart';
import 'package:html_components/utility/notification_bar.dart';
import 'dart:html';
import 'dart:async';

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(node) {}
}

void main() {
  group('utility', () {
    group('notification-bar', () {
      NotificationBarComponent notificationBar = null;
      DivElement containerElement = null;
      ContentElement contentElement = null;
      int contentHeight = 60;
      
      setUp(() {
        notificationBar = new Element.html('<h-notification-bar><h3>Message</h3></h-notificationBar>', treeSanitizer: new NullTreeSanitizer());
        document.body.append(notificationBar);
      });
      
      tearDown(() {
        notificationBar.remove();
      });
      
      test('the given child elements must be present inside the container', () {
        ContentElement content = notificationBar.shadowRoot.querySelector('#container content');
        HeadingElement heading = content.getDistributedNodes()[0];
        
        expect(heading, isNotNull);
        expect(heading.text, equals('Message'));
      });
      
      test('show and hide should animate the container', () {
        DivElement container = notificationBar.shadowRoot.querySelector('#container');
        
        expect(container.style.height, equals('0px'));
        expect(notificationBar.visible, isFalse);
        
        Completer completer = new Completer();
        
        notificationBar.show();
        
        new Timer(const Duration(milliseconds: 500), () {
          expect(container.style.height, '${notificationBar.contentHeight}px');
          expect(notificationBar.visible, isTrue);
          
          notificationBar.hide();
          
          new Timer(const Duration(milliseconds: 500), () {
            expect(container.style.height, '0px');
            expect(notificationBar.visible, isFalse);
            
            completer.complete();
          });
        });
        
        return completer.future;
      });
    });
  });
}