import 'dart:isolate' as Isolate;
import 'package:peon/peon_task.dart';
import 'package:peon/peon_logger.dart';

main() {
  PeonTask.task((Map map, PeonLogger logger) {
    for(String file in map['files']) {
      logger.log("Generating Doc for $file");
    }
  });
}