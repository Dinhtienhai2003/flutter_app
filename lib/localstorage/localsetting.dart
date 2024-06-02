import 'package:ontap_sharedprefences/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalSetting {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isDark = false;
  bool _isGiam = false;

  Future<Map<String, bool>> getData() async {
    Map<String, bool> mapSetting = {};

    mapSetting["isDark"] = false;
    ;
    mapSetting["isGiam"] = false;
    final SharedPreferences prefs = await _prefs;
    final bool? isDarkJson = prefs.getBool('isDark') ?? _isDark;
    final bool? isGiamJson = prefs.getBool('isGiam') ?? _isGiam;

    if (isDarkJson != null) {
      _isDark = isDarkJson;
      _isGiam = isGiamJson ?? false;
      mapSetting["isDark"] = _isDark;
      mapSetting["isGiam"] = _isGiam;

      return mapSetting;
    } else {
      return mapSetting;
    }
  }

  Future<void> setData(bool? dark, bool? sort) async {
    final SharedPreferences prefs = await _prefs;
    if (dark != null) {
      prefs.setBool('isDark', dark);
    }
    if (sort != null) {
      prefs.setBool('isGiam', sort);
    }
  }
}
