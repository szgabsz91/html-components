# HTML Components
===============

[![Build Status](https://drone.io/github.com/szgabsz91/html-components/status.png)](https://drone.io/github.com/szgabsz91/html-components/latest)

HTML Components is a reusable component library containing 47 components written in HTML and Dart based on the functionality of the [Primefaces](http://primefaces.org) JSF component library.

## Usage

If you want to try HTML Components, include this fragment in your `pubspec.yaml` file:

    dependencies:
      html_components: any

The library can be used in HTML and Dart.

For using the components in your HTML page, first you must import the component in the `head` section of the page, then put an instance of the component on your page.

A basic example:

    <!DOCTYPE html>
    <html>
      <head>
        <title>Utility - Clock</title>
        <link rel="import" href="packages/html_components/utility/clock.html">
        <script type="application/dart">export 'package:polymer/init.dart';</script>
        <script src="packages/browser/dart.js"></script>
      </head>
      <body>
        <h-clock size="500"></h-clock>
      </body>
    </html>

If you want to interact with the components in Dart, you must import the component class like this:

    import 'package:html_components/utility/clock.dart';

Alternatively, you can import the whole library that includes every class you might need:

    import 'package:html_components/html_components.dart';

It is recommended to create your custom elements if you want to listen for component events or bind HTML attributes to your Dart objects, because Polymer Expressions don't work outside of custom elements.

## Examples

For more examples and code samples, please visit this page: http://szgabsz91.github.io/html-components

Here you can find most of the use cases of the components.

Right now the examples must be viewed in Dartium, beacuse the dart2js compiler does not produce equivalent code to the Dart version.

If a component has some issues in Chrome or Chrome Canary, you can see a brief description on the component's page.

## Components in the Library

The list of components that are already migrate from the old Web UI framework to Polymer.dart:

* Data Components
	* Carousel
	* Column
	* Datagrid
	* Datatable
	* Listbox
	* Paginator
	* Picklist
	* Row Expansion
	* Tag
	* Tagcloud
	* Tree
	* Tree Node
	* Treetable

* Dialog Components
	* Confirmation Dialog
	* Dialog

* Input Components
	* Autocomplete
	* Boolean Button
	* Masked Input
	* Rating
	* Select Button
	* Select Checkbox Menu
	* Select Item

* Menu Components
	* Breadcrumb
	* Context Menu
	* Menubar
	* Menu Button
	* Menu Item
	* Menu Separator
	* Split Button
	* Submenu

* Multimedia Components
	* Feed Reader
	* Gallery
	* Image Compare
	* Lightbox
	* Photocam

* Panel Components
	* Accordion
	* Panel
	* Tab
	* Tabview

* Utility Components
	* Clock
	* Draggable
	* Growl
	* Growl Message
	* Item Template
	* Notification Bar
	* Resizable
	* Safe Html