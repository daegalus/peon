import 'package:logging/logging.dart';

class PeonLogger {
  String _taskName;
  Logger logger;

  PeonLogger(String taskName) {
    _taskName = taskName;
    logger = new Logger(taskName);
  }

  void log(String message) {
    print('[$_taskName] $message');
  }
}