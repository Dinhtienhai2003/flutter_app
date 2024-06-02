import 'package:ontap_sharedprefences/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalstorageTask {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Task> tasks = [];

  get getTasks => tasks;

  Future<List<Task>> getData() async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? tasksJson = prefs.getStringList('tasks');
    print("du lieu lay tu getdatalocal json : ${tasksJson}");

    if (tasksJson != null) {
      List<Task>? tasksTmp = [];
      return tasksJson.map((json) => Task.fromMap(jsonDecode(json))).toList();
    } else {
      return [];
    }
  }

  Future<void> setData(List<Task> tmp) async {
    List<String> tasksJson =
        tmp.map((task) => jsonEncode(task.toMap())).toList();

    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('tasks', tasksJson);

    print("list string vua set : ${tasksJson}");
  }
}
