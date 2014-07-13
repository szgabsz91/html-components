import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'dart:js';
import 'dart:convert';
import 'package:html_components/html_components.dart' show NullTreeSanitizer, GrowlComponent;

@CustomTag('showcase-item')
class ShowcaseItem extends PolymerElement {
  
  bool noscript = false;
  
  ShowcaseItem.created() : super.created();
  
  void setCodeSamples(List<String> urls) {
    var futures = new List<Future>();
    var tabStrings = new Map<String, String>();
    var sanitizer = const HtmlEscape();
    var htmlBuffer = new StringBuffer('<h-tabview>');
    
    urls.forEach((String url) {
      String language = url.substring(url.lastIndexOf('.') + 1);
      String filename = url.substring(url.lastIndexOf('/') + 1);
      
      futures.add(HttpRequest.getString(url).then((String content) {
        String modifiedContent = _modify(content, language);
        String escapedContent = sanitizer.convert(modifiedContent);
        String prettyContent = context.callMethod('prettyPrintOne', [escapedContent, language, false]);
        tabStrings[url] = '<h-tab header="${filename}"><pre class="prettyprint lang-${language} prettyprinted"><a href="https://github.com/szgabsz91/html-components/tree/master/example/${url}" class="link" target="_blank"><b class="glyphicon glyphicon-new-window"></b></a>${prettyContent}</pre></h-tab>';
      }));
    });
    
    Future.wait(futures)
      .then((_) {
        for (String url in urls) {
          htmlBuffer.write(tabStrings[url]);
        }
        htmlBuffer.write('</h-tabview>');
        var tabview = new Element.html(htmlBuffer.toString(), treeSanitizer: new NullTreeSanitizer());
        $['tabviewContainer'].children
          ..clear()
          ..add(tabview);
      })
      .catchError((error) {
        GrowlComponent.postMessage('The transformer failed', 'Dart code sample not found');
      });
  }
  
  String _modify(String content, String language) {
    String result = content;
    
    result = result.replaceAll(new RegExp(r'\.\./'), '');
    
    if (language == 'html') {
      result = result.replaceAll(new RegExp('\r?\n<link rel="import" href="(../)?showcase/item.html">'), '');
      result = result.replaceAll(new RegExp(r' extends="(.*)"'), '');
      result = result.replaceAll(new RegExp('\r?\n    \r?\n    <shadow></shadow>'), '');
      result = result.replaceAll('//szgabsz91.github.io/html-components/', '');
      
      if (noscript) {
        result = result.replaceAllMapped(new RegExp('<polymer-element name="(.*)">'), (Match match) => '<polymer-element name="${match.group(1)}" noscript>');
        result = result.replaceAll(new RegExp('\r?\n  \r?\n  <script(.*)</script>'), '');
      }
    }
    else if (language == 'dart') {
      result = result.replaceAll(new RegExp('import \'showcase/item.dart\';\r?\n'), '');
      result = result.replaceAll('ShowcaseItem', 'PolymerElement');
      result = result.replaceAll(new RegExp('\r?\n    super.setCodeSamples(.*)\r?\n'), '');
      result = result.replaceAll(' {  }', ';');
    }
    
    return result;
  }
  
}