import 'package:ontap_sharedprefences/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalstorageTask {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Task> tasks = [];

  get getTasks => tasks;

  void setTasks(List<Task> tmp) {
    tasks = tmp;
  }

  Future<List<Task>> getData() async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? tasksJson = prefs.getStringList('tasks');
    if (tasksJson != null && tasksJson.isNotEmpty) {
      tasks = tasksJson
          .map((taskJson) => Task.fromMap(jsonDecode(taskJson)))
          .toList();
    } else {
      tasks = [];
    }
    return tasks;
  }

  Future<void> setData() async {
    List<String> tasksJson =
        tasks.map((task) => jsonEncode(task.toMap())).toList();

    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('tasks', tasksJson);
  }
}
