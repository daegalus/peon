import 'dart:async';
import 'dart:io';
import 'dart:isolate' as Isolate;
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

YamlMap config = new Map();
Logger log = new Logger("Peon");

void main() {
  readConfiguration().then((YamlMap result) {
    if(result.length != 0) {
      config = result;
      runTasks();
    } else {
      log.severe("Loading of the configuration failed.");
    }
  });
}

Future<YamlMap> readConfiguration() {
  File config = new File("Peonfile.yaml");
  Completer<YamlMap> completer = new Completer<YamlMap>();
  config.exists().then((bool result) {
    if(result) {
      config.readAsString().then((String fileContents) {
        YamlMap configuration = loadYaml(fileContents);
        print(configuration);
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
  print(config);

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
      Isolate.SendPort port = Isolate.spawnUri(taskFile.path);
      port.call(config['${task}']).then((String result) {
        print(result);
      });
    } else {
      print('could not find task! $task');
      exit(1);
    }
  });
}
void runPubTask(String pubTask) {
  File pubTaskFile = new File("packages/peon-${pubTask}/${pubTask}.dart");
  pubTaskFile.exists().then((bool exists) {
    if(exists) {
      Isolate.SendPort port = Isolate.spawnUri(pubTaskFile.path);
      port.call(config['${pubTask}']).then((String result) {
        print(result);
      });
    }
  });
}