import 'package:flutter/material.dart';
import '../localstorage/statusTask.dart';

class StatusTaskProvider extends ChangeNotifier {
  final LocalstorageStatusTask _localStoreTask = LocalstorageStatusTask();
  Map<String, dynamic> _mapStatusTask = {};

  Map<String, dynamic> get mapStatusTask => _mapStatusTask;

  Future<void> setMapStatusTask(Map<String, dynamic> mapStatusTask) async {
    _mapStatusTask = mapStatusTask;
    await _localStoreTask.setData(_mapStatusTask);
    notifyListeners();
  }

  Future<void> getMapStatusTask() async {
    _mapStatusTask = await _localStoreTask.getData();
    notifyListeners();
  }

  Future<bool> getItemMapStatusTask(String id) {
    return _mapStatusTask[id];
  }

  void updateTaskStatus(String taskId, bool newStatus) {
    if (_mapStatusTask.containsKey(taskId)) {
      _mapStatusTask[taskId]['status'] = newStatus;
      _localStoreTask.setData(_mapStatusTask);
      notifyListeners();
    }
  }
}
