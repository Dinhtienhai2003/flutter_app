import 'package:ontap_sharedprefences/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalSetting {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isDark = false;

  Future<bool> getData() async {
    final SharedPreferences prefs = await _prefs;
    final bool? isDarkJson = prefs.getBool('isDark') ?? _isDark;

    if (isDarkJson != null) {
      _isDark = isDarkJson;
    } else {
      _isDark = false;
    }
    return isDarkJson!;
  }

  Future<void> setData(bool tmp) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isDark', tmp);
  }
}
