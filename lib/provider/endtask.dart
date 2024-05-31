import 'package:flutter/material.dart';
import '../localstorage/statusTask.dart';

class EndTaskProvider extends ChangeNotifier {
  final LocalstorageStatusTask localEndStoreTask = LocalstorageStatusTask();
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

  void updateTaskStatus(String taskId, bool newStatus) {
    if (mapEndTask.containsKey(taskId)) {
      mapEndTask[taskId]['end'] = newStatus;
      localEndStoreTask.setData(mapEndTask);
      notifyListeners();
    }
  }
}
