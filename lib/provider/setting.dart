import 'package:flutter/material.dart';

import '../localstorage/localsetting.dart';

class SettingProvider extends ChangeNotifier {
  final localSetting = LocalSetting();
  bool _isDark = false;

  SettingProvider() {
    localSetting.getData().then((value) {
      _isDark = value;
      print("gia tri _isDark : ${_isDark}");
      notifyListeners();
    });
  }

  get isDark => _isDark;

  void setBrightness(bool value) {
    _isDark = value;

    localSetting.setData(_isDark);
    print("set _isDark : ${_isDark}");

    notifyListeners();
  }
}
