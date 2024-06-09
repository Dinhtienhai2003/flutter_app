import 'package:ontap_sharedprefences/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalstorageLog {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> logs = [];

  get getLogs => logs;

  void setLogs(List<String> tmp) {
    logs = tmp;
  }

  Future<void> clearData() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('logs');
  }

  Future<List<String>> getData() async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? logsJson = prefs.getStringList('logs');
    if (logsJson != null && logsJson.isNotEmpty) {
      logs = logsJson.map((log) {
        log = log.replaceAll('\\', '');
        log = log.replaceAll('""', '"');
        log = log.replaceAll('"', '');
        return log;
      }).toList();
    } else {
      logs = [];
    }
    return logs;
  }

  Future<void> setData() async {
    List<String> logJson = logs.map((log) => jsonEncode(log)).toList();

    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('logs', logJson);
  }
}
