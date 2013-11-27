library test_runner;

import 'package:hop/hop.dart';
import 'dart:io';

main(List<String> args) {
  addTask('test', createUnitTestTask());
  runHop(args);
}

Task createUnitTestTask() {
  return new Task((TaskContext context) {
    context.info("Running unit tests...");
    
    return Process
      .run('content_shell', ['--dump-render-tree', 'test/browser_tests.html'])
      .then((ProcessResult process) {
        context.info(process.stdout);
      });
  });
}