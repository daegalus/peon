import 'dart:isolate' as Isolate;
import 'peon_logger.dart';

class PeonTask {
  static void task(Function passedFunction) {
    Isolate.ReceivePort port = Isolate.port;

    port.receive((Map map, Isolate.SendPort replyTo) {
      PeonLogger logger = new PeonLogger(map['taskName']);
      passedFunction(map, logger);
      replyTo.call("Completed");
    });
  }
}