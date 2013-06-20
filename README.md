# Peon

A simple task runner to run tasks for your project. It uses task files that are contributed by Pub or custom ones in a Tasks folder.

## Logic
All tasks are run as isolates, and are completely isolated from the main Peon files and other tasks. The only thing shared between them is the data from the JSON file, and only the portion related to the task.

If you are comfortable with Isolates, I am sure you can hijack the isolate and do whatever you want with the isolate, but you are still locked into the isolate scope.

## Structure
Currently, Peon looks for tasks in `packages/` and `tasks`

Tasks written as Pub packages need to be in a packaged titled `peon-{taskName}` with a dart file in that file named after the task name.

Ex: packages/peon-docgen/docgen.dart
Ex: tasks/helloworld.dart

## Config File
The config file is a simple JSON object. It gets read and parsed into a map by Peon. Once read, all tasks listed under `pubtasks` will be searched for in the packages, while everything under `tasks` will be searched for in the `tasks` folder.
once those are set, the remainder of the settings are purely for the tasks you want run.

For example (mentioned exmaple is listed below) the hello-world task, has a config message entry that has a string I would like to print.

When the map entry is send to the Task, I only send the contents to the task, so from the task point of view, it will only get:

``` json
{
    "taskName": "helloworld",
    "config": {
        "message": "Hello World! :D"
    }
}
```

I inject the taskName into the map, for my own personal convenience, and maybe it will help you out too.

Your task will not have any information outside of this from the main file and is completely isolated in its task.

Below are example Peonfile.json and a Task file. There is a few helper methods provided by the library to wrap the Isolate usage and make the classes cleaner.

### Example Peonfile.json
``` json
{
    "pubtasks": [
        "hello-world"
    ],
    "tasks": [
        "docgen"
    ],
    "hello-world": {
        "config": {
            "message": "Hello World! :D"
        }
    },
    "docgen": {
        "files": [
            "peon.dart"
        ]
    }
}
```

## Example Task File
``` dart
import 'dart:isolate' as Isolate;
import 'package:peon/peon_task.dart'; // task function to wrap your logic in so that it's executed.
import 'package:peon/peon_logger.dart';  // Provides a convenient log method that prepends the taskname in square brackets before the message.

main() {
  PeonTask.task((Map map, PeonLogger logger) {
    for(String file in map['files']) {
      logger.log("Generating Doc for $file");
    }
  });
}
```
