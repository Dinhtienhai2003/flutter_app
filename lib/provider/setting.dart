import 'package:flutter/material.dart';

import '../localstorage/localsetting.dart';

class SettingProvider extends ChangeNotifier {
  final localSetting = LocalSetting();
  bool _isDark = false;

  bool _isGiam = false;

  SettingProvider() {
    localSetting.getData().then((value) {
      _isDark = value["isDark"] ?? false;
      _isGiam = value["isGiam"] ?? false;
      print("gia tri _isDark : ${_isDark}");
      notifyListeners();
    });
  }

  get isDark => _isDark;

  get isGiam => _isGiam;

  void setBrightness(bool value) {
    _isDark = value;

    localSetting.setData(_isDark, null);
    print("set _isDark : ${_isDark}");

    notifyListeners();
  }

  void setSort() {
    _isGiam = !_isGiam;

    localSetting.setData(null, _isGiam);
    print("set _isGiam : ${_isGiam}");

    notifyListeners();
  }
}
