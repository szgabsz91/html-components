library utility_tests;

import 'clock.dart' as clock;
import 'growl.dart' as growl;
import 'growl_message.dart' as growl_message;
import 'notification_bar.dart' as notification_bar;

void main() {
  clock.main();
  growl.main();
  growl_message.main();
  notification_bar.main();
}