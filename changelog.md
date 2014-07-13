# Changelog

## 0.4.0
* Updated to latest SDK (1.5.3) version
* Examples updated as a single-page application
* Code samples are now displayed in a tabview, after automatically downloading and transforming the necessary HTML and Dart files
* All the demo components inherit from the new `showcase-item` or the `showcase-collection` component, and the showcase examples were rationalized
* Added a simple and naive transformer so that the Dart files get copied to the build directory and they can be downloaded by the JS version of `showcase-item`
* The `h-growl-message` component can now display arbitrary HTML content
* The `h-resizable` component's size constraints can be reset by setting the individual attributes to `null`
* The `h-growl` component now cancels listening to the global growl event if it gets removed from the DOM
* Added a `Size` and a `StringToInt` class to the library
* The `h-select-button` component now accepts a `template` element with the `repeat` attribute
* The `h-feed-reader` component does not throw exception if the `ttl` field is null
* The `h-context-menu` component can be attached to any element under any shadow root
* The `h-tag` component has a new `target` attribute that can be used to open a new window (`_blank` target)
* The `h-carousel` component listens to the `load` event of images in case they load after the component load
* The `h-datagrid` and the `h-datatable` components' `paginatorPosition` attribute can be `both`
* Some codes were removed because the bugs they had been related to were fixed in Polymer.dart
* The icon CSS rules were moved to a separate file
* CSS fix for menu item width
* The `h-tree-node` component's `icon` attribute was renamed to `normalIcon` because of the Polymer transformer's behavior
* The `h-menu-item`, `h-submenu` and `h-split-button` components' `icon` attribute was renamed to `iconClass` because of the Polymer transformer's behavior

## 0.3.0
* Updated to latest SDK (1.5.1) and polymer (0.11.0) version
* Renamed the web folder to example
* Updated Bootstrap CSS to use /deep/ selectors
* Added the `packages/polymer/polymer.html` import to every Polymer element definition page.
* `packages/web_components/platform.js` and `packages/web_components/dart_support.js` added to the example pages instead of the `packages/polymer/polymer.html` HTML import
* `packages/browser/dart.js` removed from the example pages
* `enteredView` and `leftView` lifecycle methods replaced with `attached` and `detached` respectively
* `@host` CSS rules changed to `:host`
* Removed the dependency to the `animation` package
* An old pagination bug reintroduced by Polymer.dart was fixed in the library
* For the `h-image-compare` component, now the `before` and `after` CSS classes are required as the `:first-child` and `:last-child` pseudo selectors got out of the spec
* Fixed the animation bug in `h-accordion`
* Refactored the example CSS files, some of them could be removed
* Removed `applyAuthorStyles` from everywhere
* Removed some example dart files and modified those components to be `noscript`
* Fixed some warning messages in `pub build`
* Fixed the undefined function error in `h-paginator`
* Fixed `h-datatable` issues outside of Dartium
* The components can be used in Dartium (SDK 1.5.1), Chrome Stable 35, Chrome Canary 38, Opera 22, Firefox 30, Safari 7

## 0.2.1
* Updated to latest SDK (1.4.2) and polymer (0.10.1+1) version

## 0.2.0
* Updated to latest SDK (1.3) and polymer version
* Some bug fixes
* `example` directory renamed to `web` until the pages can be compiled without an error
* `unittest` is now a dev dependency

## 0.1.7
* tree: animate property renamed to animating to fix the naming collision with the Element class
* menu button: positioning bug fixed

## 0.1.6
* confirmation dialog is centered before shown, fix in CSS
* CSS fixes: confirmation dialog, dialog, boolean button, masked input, select item, select button, select checkbox menu
* breadcrumb fixed

## 0.1.5
* carousel's select button is now a span, initialization is async
* datatable now fires `columnresized` and `rowtoggled` events instead of `columnResized` and `rowToggled`
* treetable now fires `columnresized` instead of `columnResized`
* confirmation dialog now fires the `buttonclicked` event when a button is clicked
* autocomplete, boolean button, masked input and rating now fires `valuechanged` instead of `valueChanged`
* masked input is now a block component and can be resized horizontally
* context menu now has a `disabled` attribute
* select button and select checkbox menu now fires `selectionchanged` instead of `selectionChanged`
* orientation of menubar can now be changed dynamically
* menu button closes if a menu item is clicked
* submenu label does not fire click event
* feed reader does not fire the `refreshed` event on the first time
* gallery and image compare are now initialized 100 milliseconds after `enteredView`
* image compare is now a block component
* accordion is initialized in a `Timer.run` function instead of `scheduleMicrotask`
* panel now has two public methods: `open()` and `collapse()` to open and collapse the panel dynamically
* a tab cannot be closed in a tabview if the tab is disabled
* new property in NotificationBarComponent: z (z-index for the notification bar)
* draggable is now a block component
* growl messages animate when closed automatically after `lifetime` milliseconds
* initialization of the resizable component is now async
* examples updated

## 0.1.4
* item template renamed to safe html
* new item template component created
* the functionality of orderlist is merged into select listbox
* select listbox renamed to listbox
* feed reader, autocomplete, carousel, listbox, picklist, datagrid, paginator, tree, tree node, datatable, column, row expansion, treetable migrated to Polymer.dart
* examples added for the item template and safe html components

## 0.1.3
* draggable, resizable, panel, accordion, photocam, lightbox, image compare, gallery, boolean button, masked input, rating, select item, select button, select checkbox menu, tag, tagcloud, dialog, confirmation dialog, breadcrumb, context menu, menubar, menu button, menu item, menu separator, split button, submenu migrated to Polymer.dart

## 0.1.2

* tab, tabview migrated to Polymer.dart
* added examples for the migrated components
* added Github pages for live demo
* readme updated

## 0.1.0

* clock, growl, growl message, notification bar migrated to Polymer.dart