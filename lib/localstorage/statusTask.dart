import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalstorageStatusTask {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, dynamic> _mapStatusTask = {};

  Future<void> setData(Map<String, dynamic> listStatusTask) async {
    final SharedPreferences prefs = await _prefs;
    _mapStatusTask = listStatusTask;
    await prefs.setString('listStatusTask', json.encode(_mapStatusTask));
  }

  Future<Map<String, dynamic>> getData() async {
    final SharedPreferences prefs = await _prefs;
    final String? listStatusTaskJson = prefs.getString('listStatusTask');

    if (listStatusTaskJson != null) {
      _mapStatusTask = json.decode(listStatusTaskJson) as Map<String, dynamic>;
    }

    return _mapStatusTask;
  }
}
