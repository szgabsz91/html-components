# HTML Components

[![Build Status](https://drone.io/github.com/szgabsz91/html-components/status.png)](https://drone.io/github.com/szgabsz91/html-components/latest)

HTML Components is a reusable component library containing 47 components written in HTML and Dart based on the functionality of the [Primefaces](http://primefaces.org) JSF component library.

## Usage

If you want to try HTML Components, include this fragment in your `pubspec.yaml` file:

    dependencies:
      html_components: any

The library can be used in HTML and Dart.

The most basic example that uses one of the components:

    <!DOCTYPE html>
    <html>
      <head>
        <title>Utility - Clock</title>
        <script src="packages/web_components/platform.js"></script>
        <script src="packages/web_components/dart_support.js"></script>
        <link rel="import" href="packages/html_components/utility/clock.html">
      </head>
      <body>
        <h-clock size="500"></h-clock>
        <script type="application/dart">export 'package:polymer/init.dart';</script>
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

The examples were tested in the following browsers:

* Dartium (SDK 1.5.1)
* Chrome Stable 35
* Chrome Canary 38
* Opera 22

Most of the components should work in the following browsers, but there are some style issues:

* Firefox 30
* Safari 7

For those examples that require a server side, use [services.dart](bin/services.dart).

## Components in the Library

Here is the list of components:

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
