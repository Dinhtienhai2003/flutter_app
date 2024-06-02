import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalstorageEndTask {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, dynamic> _mapEndTask = {};

  Future<void> setData(Map<String, dynamic> mapStatusTask) async {
    final SharedPreferences prefs = await _prefs;
    _mapEndTask = mapStatusTask;
    await prefs.setString('mapStatusTask', json.encode(_mapEndTask));
  }

  Future<Map<String, dynamic>> getData() async {
    final SharedPreferences prefs = await _prefs;
    final String? mapStatusTaskJson = prefs.getString('mapStatusTask');

    if (mapStatusTaskJson != null) {
      _mapEndTask = json.decode(mapStatusTaskJson) as Map<String, dynamic>;
    }

    return _mapEndTask;
  }
}
