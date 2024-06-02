import 'package:flutter/material.dart';
import '../localstorage/localEnd.dart';
import '../localstorage/statusTask.dart';

class EndTaskProvider extends ChangeNotifier {
  final LocalstorageEndTask localEndStoreTask = LocalstorageEndTask();
  Map<String, dynamic> mapEndTask = {};

  Map<String, dynamic> get GetMapEndTask => mapEndTask;

  Future<void> setMapEndTask(Map<String, dynamic> mapStatusTask) async {
    mapEndTask = mapStatusTask;
    await localEndStoreTask.setData(mapEndTask);
    notifyListeners();
  }

  Future<void> getMapEndTask() async {
    mapEndTask = await localEndStoreTask.getData();
    notifyListeners();
  }

  Future<bool> getItemMapEndTask(String id) {
    return mapEndTask[id];
  }

  void updateTaskStatus(String taskId, DateTime? newTime) {
    if (mapEndTask.containsKey(taskId)) {
      mapEndTask[taskId]['end'] = newTime;
      localEndStoreTask.setData(mapEndTask);
      notifyListeners();
    }
  }
}
