import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../localstorage/localLog.dart';
import '../localstorage/localTask.dart';
import '../model/task.dart';

class TaskProvider extends ChangeNotifier {
  final localTasks = LocalstorageTask();

  final localLogs = LocalstorageLog();
  List<Task> listTask = [];

  List<Task> listTaskOverDue = [];

  List<String> logs = [];

  List<Task> getListTaskOverDue() {
    return listTaskOverDue;
  }

  void updateOverdueTasks() {
    CheckIsShow();
    final now = DateTime.now();

    for (Task task in listTask) {
      if (task.end!.isBefore(now)) {
        if (listTaskOverDue.contains(task)) {
          continue;
        } else {
          listTaskOverDue.add(task);
        }
      }
    }

    notifyListeners();
  }

  void Setisshow(Task taskTmp) {
    for (Task task in listTask) {
      if (task.id == taskTmp.id) {
        task.isShow = false;

        notifyListeners();
        break;
      }
    }
  }

  void AddTaskOverDue(Task task) {
    listTaskOverDue.add(task);
    notifyListeners();
  }

  void ClearLog() {
    localLogs.clearData();
    logs.clear();
    notifyListeners();
  }

  Stream<DateTime> get timeStream {
    return Stream.periodic(Duration(seconds: 1), (_) => DateTime.now())
        .asBroadcastStream();
  }

  TaskProvider() {
    localTasks.getData().then((tasks) {
      listTask = tasks;
      updateOverdueTasks();
      if (listTask.isNotEmpty) {
        notifyListeners();
      }
    });

    localLogs.getData().then((logsList) {
      logs = logsList;
      if (logsList.isNotEmpty) {
        notifyListeners();
      }
    });
    timeStream.listen((now) {
      updateOverdueTasks();
    });
  }

  List<String> GetLogs() {
    return logs.reversed.toList();
  }

  void CheckIsShow() {
    for (Task task in listTask) {
      if (listTaskOverDue.contains(task)) {
        task.isShow = false;
      }
    }
  }

  List<Task> GetListTask() {
    CheckIsShow();
    return listTask;
  }

  String LayGioHienTai() {
    return DateFormat('dd-MM-yyy HH:mm:ss').format(DateTime.now());
  }

  void SetStatus(String id, bool status) {
    for (Task task in listTask) {
      if (task.id == id) {
        task.status = status;

        if (status) {
          logs.add(
              'Nhiệm vụ ${task.ghiChu} đã thay đổi trạng thái hoàn thành lúc ${LayGioHienTai()}');
        } else {
          logs.add(
              "Nhiệm vụ ${task.ghiChu} đã thay đổi trạng thái chữa hoàn thành lúc ${LayGioHienTai()}");
        }
        CapNhatDuLieuLog();
        notifyListeners();
        return;
      }
    }
  }

  bool GetStatus(String id) {
    for (Task task in listTask) {
      if (task.id == id) {
        return task.status ?? false;
      }
    }

    return false;
  }

  Task? GetTaskDetails(String id) {
    for (Task task in listTask) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  Future<void> CapNhatDuLieuLog() async {
    localLogs.setLogs(logs);
    await localLogs.setData();
    localLogs.getData().then((logsList) {
      logs = logsList;
      notifyListeners();
    });
  }

  Future<void> CapNhatDuLieu() async {
    localTasks.setTasks(listTask);
    await localTasks.setData();
    localTasks.getData().then((tasks) {
      listTask = tasks;
      notifyListeners();
    });
  }

  void AddTask(int uuTien, String ghiChu, DateTime begin, DateTime end) async {
    final task = Task(uuTien: uuTien, ghiChu: ghiChu, end: end);
    listTask.add(task);
    CapNhatDuLieu();

    logs.add("Nhiệm vụ ${ghiChu} đã được thêm lúc ${LayGioHienTai()}");
    CapNhatDuLieuLog();
    updateOverdueTasks();
  }

  void UpdateTask(
      String id, int uuTien, String ghiChu, DateTime begin, DateTime end) {
    for (Task task in listTask) {
      if (task.id == id) {
        task.uuTien = uuTien;
        task.ghiChu = ghiChu;
        task.begin = begin;
        task.end = end;
        logs.add("Nhiệm vụ ${ghiChu} đã được sửa lúc ${LayGioHienTai()}");
        CapNhatDuLieuLog();

        CapNhatDuLieu();
        updateOverdueTasks();
        return;
      }
    }
  }

  void DeleteTask(String id) {
    logs.add(
        "Nhiệm vụ ${GetTaskDetails(id)?.ghiChu} đã được xóa lúc ${LayGioHienTai()}");
    CapNhatDuLieuLog();
    for (Task task in listTask) {
      if (task.id == id) {
        listTask.remove(task);
        Task.count--;

        CapNhatDuLieu();
        return;
      }
    }
  }
}
