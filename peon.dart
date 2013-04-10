import 'dart:async';
import 'dart:io';
import 'dart:isolate' as Isolate;
import 'dart:json' as JSON;
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

Map config = new Map();
Logger log = new Logger("Peon");

void main() {
  readConfiguration().then((Map result) {
    if(result.length != 0) {
      config = result;
      runTasks();
    } else {
      log.severe("Loading of the configuration failed.");
    }
  });
}

Future<Map> readConfiguration() {
  File config = new File("Peonfile.json");
  Completer<Map> completer = new Completer<Map>();
  config.exists().then((bool result) {
    if(result) {
      config.readAsString().then((String fileContents) {
        Map configuration = JSON.parse(fileContents);
        completer.complete(configuration);
      },
      onError: (AsyncError e) {
        log.severe("Reading Peonfile.yaml failed.");
        log.severe(e.toString());
        completer.complete({});
      });
    } else {
      log.severe("Peonfile.yaml does not exist.");
      log.severe(e.toString());
      completer.complete({});
    }
  },
  onError: (AsyncError e) {
    log.severe("Peonfile.yaml stating failed.");
    log.severe(e.toString());
    completer.complete({});
  });
  return completer.future;
}

void runTasks() {
  for(String pubTask in config['pubtasks']) {
    runPubTask(pubTask);
  }

  for(String task in config['tasks']) {
    runTask(task);
  }
}

void runTask(String task) {
  File taskFile = new File("tasks/${task}.dart");
  taskFile.exists().then((bool exists) {
    if(exists) {
      Isolate.SendPort port = Isolate.spawnUri(taskFile.fullPathSync());
      port.call(config[task]).then((String result) {
        print(result);
      });
    } else {
      print('$task does not exist.');
    }
  });
}
void runPubTask(String pubTask) {
  File pubTaskFile = new File("packages/peon-${pubTask}/${pubTask}.dart");
  pubTaskFile.exists().then((bool exists) {
    if(exists) {
      print(pubTaskFile.fullPathSync());
      Isolate.SendPort port = Isolate.spawnUri(pubTaskFile.fullPathSync());
      port.call(config[pubTask]).then((String result) {
        print(result);
      });
    } else {
      print('$pubTask does not exist.');
    }
  });
}