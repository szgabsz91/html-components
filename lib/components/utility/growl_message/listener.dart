part of growl_message;

// Fix for custom events
// When <div is="x-growl-message" on-close="..."></div> will work, this can be removed.
// No an exception is thrown: Class 'DivElement' has notinstance getter 'onClose'
abstract class GrowlMessageListener {
  void onGrowlMessageClosed(GrowlMessageModel message);
}