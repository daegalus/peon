import 'dart:isolate' as Isolate;

main() {
  Isolate.ReceivePort port = Isolate.port;

  port.receive((Map map, Isolate.SendPort replyTo) {
    for(String file in map['files']) {
      print("Generating Doc for $file");
    }
    replyTo.call("[docgen] Theoretically should have run dartdoc on all files.").then((value) => print(value));
  });
}