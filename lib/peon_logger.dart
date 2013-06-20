class PeonLogger {
  String _taskName;
  PeonLogger(this._taskName);

  void log(String message) {
    print('[$_taskName] $message');
  }
}