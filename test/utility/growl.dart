library growl_tests;

import 'package:unittest/unittest.dart';
import 'package:polymer/polymer.dart';
import 'package:html_components/html_components.dart';
import 'dart:html';
import 'dart:async';

void main() {
  group('utility', () {
    group('growl', () {
      GrowlComponent growl = null;
      int lifetime;
      final List<GrowlMessageModel> GROWL_MESSAGES = [
        new GrowlMessageModel('Summary 1', 'Detail 1', 'info'),
        new GrowlMessageModel('Summary 2', 'Detail 2', 'warn')
      ];
      DivElement hidden = null;
      DivElement container = null;
      
      tearDown(() {
        growl.remove();
      });
      
      group('with default lifetime', () {
        setUp(() {
          growl = new Element.html(
              '<h-growl></h-growl>',
              treeSanitizer: new NullTreeSanitizer()
          );
          growl.growlMessages = GROWL_MESSAGES.toList(growable: true);
          document.body.append(growl);
          
          lifetime = 0;
          hidden = growl.shadowRoot.querySelector('#hidden');
          container = growl.shadowRoot.querySelector('#message-container');
        });
        
        test('lifetime should be 0, the hidden area should be removed', () {
          expect(growl.lifetime, equals(lifetime));
          
          Observable.dirtyCheck();
          
          Timer.run(expectAsync0(() {
            List<GrowlMessageComponent> components = container.querySelectorAll('h-growl-message').toList(growable: false);
            expect(components.length, equals(2));
            
            for (int i = 0; i < 2; ++i) {
              expect(components[i].summary, equals(GROWL_MESSAGES[i].summary));
              expect(components[i].detail, equals(GROWL_MESSAGES[i].detail));
              expect(components[i].severity, equals(GROWL_MESSAGES[i].severity));
            }
            
            expect(hidden, isNull);
          }));
        });
        
        test('addMessage should add a new message to the end of the growlMessages list', () {
          GrowlMessageModel newMessage = new GrowlMessageModel('New Summary', 'New Detail', 'fatal');
          
          growl.addMessage(newMessage);
          
          expect(growl.growlMessages.length, equals(3));
          expect(growl.growlMessages[2], equals(newMessage));
          
          Observable.dirtyCheck();
          
          Timer.run(expectAsync0(() {
            List<GrowlMessageComponent> components = container.querySelectorAll('h-growl-message').toList(growable: false);
            expect(components.length, equals(3));
            
            expect(components[2].summary, equals(newMessage.summary));
            expect(components[2].detail, equals(newMessage.detail));
            expect(components[2].severity, equals(newMessage.severity));
          }));
        });
        
        test('addMessage should add a new message to the beginning of the growlMessages list if the optional prepend parameter is true', () {
          GrowlMessageModel newMessage = new GrowlMessageModel('New Summary', 'New Detail', 'fatal');
          
          growl.addMessage(newMessage, prepend: true);
          
          expect(growl.growlMessages.length, equals(3));
          expect(growl.growlMessages[0], equals(newMessage));
          
          Observable.dirtyCheck();
          
          Timer.run(expectAsync0(() {
            List<GrowlMessageComponent> components = container.querySelectorAll('h-growl-message').toList(growable: false);
            expect(components.length, equals(3));
            
            expect(components[0].summary, equals(newMessage.summary));
            expect(components[0].detail, equals(newMessage.detail));
            expect(components[0].severity, equals(newMessage.severity));
          }));
        });
        
        skip_test('removeMessage should remove the given message from the growlMessages list', () {
          growl.removeMessage(GROWL_MESSAGES[0]);
          
          expect(growl.growlMessages.length, equals(1));
          expect(growl.growlMessages[0], equals(GROWL_MESSAGES[1]));
          
          Observable.dirtyCheck();
          
          Timer.run(expectAsync0(() {
            List<GrowlMessageComponent> components = container.querySelectorAll('h-growl-message').toList(growable: false);
            expect(components.length, equals(1));
            
            expect(components[0].summary, equals(GROWL_MESSAGES[1].summary));
            expect(components[0].detail, equals(GROWL_MESSAGES[1].detail));
            expect(components[0].severity, equals(GROWL_MESSAGES[1].severity));
          }));
        });
        
        test('closing a growl message should call onGrowlMessageClosed that should remove the model of the component from the growlMessages list', () {
          Observable.dirtyCheck();
          
          Timer.run(expectAsync0(() {
            List<GrowlMessageComponent> components = container.querySelectorAll('h-growl-message').toList(growable: false);
            GrowlMessageComponent component = components[0];
            
            component.onClosing();
            
            new Timer(const Duration(milliseconds: 1000), expectAsync0(() {
              expect(growl.growlMessages.length, equals(1));
              
              expect(growl.growlMessages[0].summary, GROWL_MESSAGES[1].summary);
              expect(growl.growlMessages[0].detail, GROWL_MESSAGES[1].detail);
              expect(growl.growlMessages[0].severity, GROWL_MESSAGES[1].severity);
            }));
          }));
        });
        
        test('postMessage should add the given message to the beginning of the growlMessages list', () {
          GrowlMessageModel newMessage = new GrowlMessageModel('New Summary', 'New Detail', 'fatal');
          
          GrowlComponent.postMessage(newMessage.summary, newMessage.detail, newMessage.severity);
          
          expect(growl.growlMessages.length, equals(3));
          
          expect(growl.growlMessages[0].summary, equals(newMessage.summary));
          expect(growl.growlMessages[0].detail, equals(newMessage.detail));
          expect(growl.growlMessages[0].severity, equals(newMessage.severity));
        });
      });
      
      group('with custom lifetime', () {
        setUp(() {
          growl = new Element.html(
              '<h-growl lifetime="1000"></h-growl>',
              treeSanitizer: new NullTreeSanitizer()
          );
          growl.growlMessages = GROWL_MESSAGES.toList(growable: true);
          document.body.append(growl);
          
          lifetime = 1000;
          hidden = growl.shadowRoot.querySelector('#hidden');
          container = growl.shadowRoot.querySelector('#message-container');
        });
        
        test('lifetime should be the given HTML attribute', () {
          expect(growl.lifetime, equals(lifetime));
        });
        
        skip_test('addMessage should call removeMessage in lifetime milliseconds', () {
          GrowlMessageModel newMessage = new GrowlMessageModel('New Summary', 'New Detail', 'fatal');
          
          growl.addMessage(newMessage);
          
          expect(growl.growlMessages.length, equals(3));
          
          new Timer(new Duration(milliseconds: lifetime), expectAsync0(() {
            expect(growl.growlMessages.length, equals(2));
            
            for (int i = 0; i < 2; ++i) {
              expect(growl.growlMessages[i].summary, equals(GROWL_MESSAGES[i].summary));
              expect(growl.growlMessages[i].detail, equals(GROWL_MESSAGES[i].detail));
              expect(growl.growlMessages[i].severity, equals(GROWL_MESSAGES[i].severity));
            }
          }));
        });
      });
    });
  });
}