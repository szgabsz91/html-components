import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

@initMethod
void main() {
  scheduleMicrotask(() {
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
  });
}

void closeDropdownMenu() {
  Element dropdown = document.querySelector('.dropdown.open');
  
  if (dropdown != null) {
    dropdown.classes.remove('open');
  }
}