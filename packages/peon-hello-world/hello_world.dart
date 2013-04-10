import 'dart:isolate' as Isolate;

main() {
  Isolate.ReceivePort port = Isolate.port;

  port.receive((Map map, Isolate.SendPort replyTo) {
    print("${map['config']['message']}");
    replyTo.call("[hello-world] Completed.").then((value) => print(value));
  });
}


