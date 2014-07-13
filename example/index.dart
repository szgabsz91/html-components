import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:html_components/html_components.dart' show NullTreeSanitizer, GrowlComponent;

String _defaultHash = '/home';

void main() {
  initPolymer().run(() {
    // Open the dropdown if it is clicked
    document.querySelectorAll('.dropdown').forEach((LIElement menuItem) {
      menuItem.querySelector('a').onClick.listen((MouseEvent event) {
        event
          ..preventDefault()
          ..stopPropagation();
        
        closeDropdownMenu();
        
        menuItem.classes.toggle('open');
      });
    });
    
    // Close the dropdown menu if the user clicks outside
    document.onClick.listen((MouseEvent event) {
      closeDropdownMenu();
    });
    
    // Listen to hash changed event
    window.onHashChange.listen((e) {
      if (window.location.hash.isNotEmpty) {
        onHashChanged(window.location.hash.substring(2));
      }
    });
    if (window.location.hash.isEmpty) {
      window.location.hash = _defaultHash;
    }
    else {
      onHashChanged(window.location.hash.substring(2));
    }
  });
}

void closeDropdownMenu() {
  Element dropdown = document.querySelector('.dropdown.open');
  
  if (dropdown != null) {
    dropdown.classes.remove('open');
  }
}

void onHashChanged(String hash) {
  var parts = hash.split('/');
  
  // Check if a demo page exists and redirect to index if not
  var link = getLink(parts);
  var linkHref = 'demo/${link}.html';
  var linkElement = document.querySelector('link[href="${linkHref}"]');
  var elementName = getElementName(parts);
  var polymerElement = document.querySelector('polymer-element[name="${elementName}"]');
  if (linkElement == null && polymerElement == null) {
    window.location.hash = _defaultHash;
    GrowlComponent.postMessage('Page "#/${hash}" not found!', 'If you think this is a bug, please report an issue on <a href="https://github.com/szgabsz91/html-components/issues/new" target="_blank">GitHub</a>!');
  }
  else {
    // Remove global growl
    var globalGrowl = document.querySelector('h-growl');
    if (globalGrowl != null) {
      globalGrowl.remove();
    }
  }
  
  swapContent(elementName);
  
  // Change the active menu item
  var anchor = document.querySelector('ul.nav li a[href="#/${link}"]');
  var newItem = anchor.parentNode;
  var oldItems = document.querySelectorAll('ul.nav li.active');
  var dropDown = newItem.parentNode.parentNode;
  oldItems.forEach((LIElement item) => item.classes.remove('active'));
  newItem.classes.add('active');
  if (dropDown.classes.contains('dropdown')) {
    dropDown.classes.add('active');
  }
}

void swapContent(String elementName) {
  var content = document.querySelector('#content');
  var demoElement = new Element.html('<${elementName}></${elementName}>', treeSanitizer: new NullTreeSanitizer());
  document.querySelector('#content').children
    ..clear()
    ..add(demoElement);
  window.scroll(0, 0);
}

String getLink(List<String> parts) {
  if (parts.length == 1) {
    return parts[0];
  }
  
  return '${parts[0]}/${parts[1]}';
}

String getElementName(List<String> parts) {
  if (parts.length == 1) {
    return '${parts[0]}-demo';
  }
  
  return '${parts[1]}-demo';
}