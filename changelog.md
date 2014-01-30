# Changelog

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