import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../localstorage/localLog.dart';
import '../localstorage/localTask.dart';

import '../localstorage/statusTask.dart';
import '../model/task.dart';
import 'endtask.dart';
import 'statustask.dart';

class TaskProvider extends ChangeNotifier {
  final localTasks = LocalstorageTask();
  Map<String, dynamic> mapStatusTask = {};
  Map<String, dynamic> mapEndTask = {};

  final localEndTasks = EndTaskProvider();

  final localStatusTask = LocalstorageStatusTask();

  final localLogs = LocalstorageLog();
  List<Task> listTask = [];

  List<String> listIdTaskOverDue = [];

  List<String> logs = [];

//TODO chung
  TaskProvider() {
    //localStatusTask.getMapEndTask
    // localEndTasks.getMapEndTask().then((map) {
    //   mapEndTask = localEndTasks.GetMapEndTask;
    // });

    localStatusTask.getData().then((map) {
      mapStatusTask = map;
    });

    //lấy dữ liệu từ local
    setListTaskFromLocal()
        .then((value) => print("du lieu load duoc : ${listTask}"));

    localLogs.getData().then((value) => logs = value);

    timeStream.listen((now) {
      updateOverdueTasks();
    });

    notifyListeners();
  }

  DateTime? getEndFromMap(String id) {
    return mapEndTask[id] ?? DateTime.now();
  }

  bool getStatusFromMap(String id) {
    return mapStatusTask[id] ?? false;
  }

  String LayGioHienTai() {
    return DateFormat('dd-MM-yyy HH:mm:ss').format(DateTime.now());
  }

  //TODO task hết hạn

  void updateOverdueTasks() {
    final now = DateTime.now();

    for (Task task in listTask) {
      if (task.end != null && task.end!.isBefore(now)) {
        if (listIdTaskOverDue.contains(task.id)) {
          continue;
        } else {
          listIdTaskOverDue.add(task.id);
          SetIsShow(task.id);
        }
      }
    }

    notifyListeners();
  }

  List<Task> getListTaskOverDue() {
    List<Task> listTaskOverDue = [];

    for (Task task in listTask) {
      if (listIdTaskOverDue.contains(task.id)) {
        listTaskOverDue.add(task);
      }
    }
    return listTaskOverDue;
  }

  Stream<DateTime> get timeStream {
    return Stream.periodic(Duration(seconds: 1), (_) => DateTime.now())
        .asBroadcastStream();
  }

  void SetIsShow(String id) {
    for (Task task in listTask) {
      if (task.id == id) {
        task.isShow = false;
      }
      notifyListeners();
    }
  }

  //TODO task chưa hết hạn

  Future<void> AddTask(
      int uuTien, String ghiChu, DateTime begin, DateTime? end) async {
    final task = Task(uuTien: uuTien, ghiChu: ghiChu, end: end);
    listTask.add(task);

    // logs.add("Nhiệm vụ ${ghiChu} đã được thêm lúc ${LayGioHienTai()}");
    await CapNhatDuLieuLog();
    await GhiListTaskVaoLocal(listTask);
  }

  Future<void> UpdateTask(String id, int uuTien, String ghiChu, DateTime begin,
      DateTime? end) async {
    for (Task task in listTask) {
      if (task.id == id) {
        task.uuTien = uuTien;
        task.ghiChu = ghiChu;
        task.begin = begin;
        task.end = end;

        //await localEndTasks.setMapEndTask(mapEndTask);

        // logs.add("Nhiệm vụ ${ghiChu} đã được sửa lúc ${LayGioHienTai()}");
        await CapNhatDuLieuLog();
        await GhiListTaskVaoLocal(listTask);

        return;
      }
    }
  }

  Future<void> DeleteTask(String id) async {
    // logs.add(
    //     "Nhiệm vụ ${GetTaskDetails(id)?.ghiChu} đã được xóa lúc ${LayGioHienTai()}");
    CapNhatDuLieuLog();
    for (Task task in listTask) {
      if (task.id == id) {
        listTask.remove(task);
        listIdTaskOverDue.remove(task.id);
        await GhiListTaskVaoLocal(listTask);

        return;
      }
    }
  }

  List<Task> GetListTask() {
    return listTask;
  }

  Future<void> Setisshow(Task taskTmp) async {
    for (Task task in listTask) {
      if (task.id == taskTmp.id) {
        task.isShow = false;
        await GhiListTaskVaoLocal(listTask);

        notifyListeners();
        break;
      }
    }
  }

  Future<void> SetStatus(String id, bool status) async {
    for (Task task in listTask) {
      if (task.id == id) {
        mapStatusTask[id] = status;
        await localStatusTask.setData(mapStatusTask);
        logs.add(
            'Nhiệm vụ ${task.ghiChu} đã thay đổi trạng thái hoàn thành lúc ${LayGioHienTai()}');

        // } else {
        //   logs.add(
        //       "Nhiệm vụ ${task.ghiChu} đã thay đổi trạng thái chữa hoàn thành lúc ${LayGioHienTai()}");
        // }

        await CapNhatDuLieuLog();
        await GhiListTaskVaoLocal(listTask);

        notifyListeners();
        return;
      }
    }
  }

  bool GetStatus(String id) {
    return mapStatusTask[id];
  }

  Task? GetTaskDetails(String id) {
    for (Task task in listTask) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  //TODO log

  void ClearLog() {
    localLogs.clearData();
    logs.clear();
    notifyListeners();
  }

  List<String> GetLogs() {
    return logs.reversed.toList();
  }

  Future<void> CapNhatDuLieuLog() async {
    await localLogs.setData(logs);
    localLogs.getData().then((logsList) {
      logs = logsList;
      notifyListeners();
    });
  }

  //TODO Local Task

  Future<void> setListTaskFromLocal() async {
    listTask = await localTasks.getData();
  }

  Future<void> GhiListTaskVaoLocal(List<Task> list) async {
    await localTasks.setData(list);
  }
}
