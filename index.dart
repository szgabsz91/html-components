import 'dart:html';
import 'dart:async';
import 'package:route/client.dart';
import 'package:polymer/polymer.dart';

final String origin = window.location.pathname;

final List<UrlPattern> urlPatterns = [
  new UrlPattern('${origin}'),
  new UrlPattern('${origin}#'),
  new UrlPattern('${origin}#!/'),
  new UrlPattern('${origin}#!/home'),
  new UrlPattern('${origin}#!/(data|dialog|input|menu|multimedia|panel|utility)/(.*)')
];

void main() {
  initPolymer();
  
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
    
    // Set up client side router
    Router router = new Router();
    for (UrlPattern urlPattern in urlPatterns) {
      router.addHandler(urlPattern, showView);
    }
    router.listen(ignoreClick: true);
    
    // Navigate to the home page if no route is present
    if (window.location.hash == '' || window.location.hash == '!/') {
      router.gotoPath('${origin}#!/home', null);
    }
    
    // Show the initial view
    showView('${origin}${window.location.hash}');
    
    // Remove hidden visibility from the demo components and
    // set display to none if the component should not be visible
    document.querySelector('#content').classes.remove('visibility-hidden-children');
    for (Element child in document.querySelector('#content').children) {
      if (!child.classes.contains('visible')) {
        child.classes.add('hidden');
      }
    }
  });
  
  new Timer(const Duration(milliseconds: 100), () {
    var resizableDemo = document.querySelector('resizable-demo');
    if (resizableDemo != null) {
      if (!resizableDemo.classes.contains('visible')) {
        resizableDemo.classes.add('hidden');
      }
      document.querySelector('#content').children.add(resizableDemo);
    }
  });
}

void closeDropdownMenu() {
  Element dropdown = document.querySelector('.dropdown.open');
  
  if (dropdown != null) {
    dropdown.classes.remove('open');
  }
}

void showView(String path) {
  path = path.replaceAll('${origin}/', '').replaceAll(origin, '').replaceAll('#!/', '').replaceAll('!/', '');
  
  document.querySelectorAll('li.active').forEach((LIElement activeMenuItem) {
    activeMenuItem.classes.remove('active');
  });
  
  if (path == 'home') {
    document.querySelector('a[href="#!/home"]').parent.classes.add('active');
    
    hideVisibleDemo();
    showComponentDemo('index');
  }
  else {
    int slashIndex = path.indexOf('/');
    String category = path.substring(0, slashIndex);
    String component = path.substring(slashIndex + 1);
    
    AnchorElement anchor = document.querySelector('a[href="#!/${category}/${component}"]');
    LIElement parentMenuItem = anchor.parent;
    LIElement rootMenuItem = parentMenuItem.parent.parent;
    parentMenuItem.classes.add('active');
    rootMenuItem.classes.add('active');
    
    hideVisibleDemo();
    showComponentDemo(component);
  }
}

void hideVisibleDemo() {
  Element visibleElement = document.querySelector('.visible');
  
  if (visibleElement != null) {
    visibleElement.classes
      ..remove('visible')
      ..add('hidden');
  }
}

void showComponentDemo(String componentName) {
  document.querySelector('${componentName}-demo').classes
    ..remove('hidden')
    ..add('visible');
  
  if (componentName == 'growl') {
    document.querySelector('h-growl').classes.add('hidden');
  }
  else {
    document.querySelector('h-growl').classes.remove('hidden');
  }
  
  if (componentName == 'context-menu') {
    var image = document.querySelector('#image');
    if (image != null) {
      image.classes.remove('hidden');
    }
    var contextMenuDemo = document.querySelector('context-menu-demo');
    if (contextMenuDemo != null) {
      contextMenuDemo.disabled = false;
    }
  }
  else {
    var image = document.querySelector('#image');
    if (image != null) {
      document.querySelector('#image').classes.add('hidden');
    }
    var contextMenuDemo = document.querySelector('context-menu-demo');
    if (contextMenuDemo != null) {
      contextMenuDemo.disabled = true;
    }
  }
}