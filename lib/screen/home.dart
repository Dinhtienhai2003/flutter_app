import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/model/task.dart';
import 'package:ontap_sharedprefences/screen/drawer.dart';
import 'package:provider/provider.dart';
import '../provider/setting.dart';
import '../provider/task.dart';
import 'Edit.dart';
import 'detailtask.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _showDeleteConfirmation(
      BuildContext context, Function deleteFunction) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: Text('Bạn có muốn xóa không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                deleteFunction();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Xóa thành công!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: DrawerScreen()),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "My App",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(
                  child: context.watch<SettingProvider>().isDark
                      ? Icon(Icons.nightlight_round, color: Colors.black)
                      : Icon(Icons.wb_sunny, color: Colors.yellow),
                  width: 40,
                ),
                Switch(
                  value: context.watch<SettingProvider>().isDark,
                  onChanged: (newValue) {
                    context.read<SettingProvider>().setBrightness(newValue);
                  },
                  activeColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Nhiệm vụ quá hạn",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              StreamBuilder<DateTime>(
                stream: context.read<TaskProvider>().timeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Consumer<TaskProvider>(
                      builder: (context, taskprovider, child) {
                        return Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      taskprovider.getListTaskOverDue().length,
                                  itemBuilder: (context, index) {
                                    final task = taskprovider
                                        .getListTaskOverDue()[index];
                                    return Card(
                                      child: ListTile(
                                        leading: Checkbox(
                                          checkColor: Colors.blue,
                                          activeColor: Colors.white,
                                          value:
                                              taskprovider.GetStatus(task.id),
                                          onChanged: (bool? value) {
                                            taskprovider.SetStatus(
                                                task.id, value!);
                                          },
                                        ),
                                        title: Text(
                                          "Ưu tiên :" + task.uuTien.toString(),
                                          style: TextStyle(
                                            color: task.uuTien < 3
                                                ? Colors.red
                                                : task.uuTien > 2 &&
                                                        task.uuTien < 6
                                                    ? Colors.orange
                                                    : task.status == true
                                                        ? Colors.grey
                                                        : null,
                                            decoration: task.status == true
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "noi dung : " + task.ghiChu,
                                          style: TextStyle(
                                            decoration: task.status == true
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: task.status == true
                                                ? Colors.grey
                                                : null,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          hoverColor: Colors.red,
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _showDeleteConfirmation(context,
                                                () {
                                              taskprovider.DeleteTask(task.id);
                                            });
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailTask(
                                                  taskprovider.GetTaskDetails(
                                                      task.id)),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nhiệm vụ hiện tại",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: taskprovider.GetListTask().length,
                                  itemBuilder: (context, index) {
                                    Task task =
                                        taskprovider.GetListTask()[index];
                                    return task.isShow == true
                                        ? Card(
                                            child: ListTile(
                                              leading: Checkbox(
                                                checkColor: Colors.blue,
                                                activeColor: Colors.white,
                                                value: taskprovider.GetStatus(
                                                    task.id),
                                                onChanged: (bool? value) {
                                                  taskprovider.SetStatus(
                                                      task.id, value!);
                                                },
                                              ),
                                              title: Text(
                                                "Ưu tiên :" +
                                                    task.uuTien.toString(),
                                                style: TextStyle(
                                                  color: task.uuTien < 3
                                                      ? Colors.red
                                                      : task.uuTien > 2 &&
                                                              task.uuTien < 6
                                                          ? Colors.orange
                                                          : task.status == true
                                                              ? Colors.grey
                                                              : null,
                                                  decoration:
                                                      task.status == true
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "Nội dung: " + task.ghiChu,
                                                style: TextStyle(
                                                  decoration:
                                                      task.status == true
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                  color: task.status == true
                                                      ? Colors.grey
                                                      : null,
                                                ),
                                              ),
                                              trailing: IconButton(
                                                hoverColor: Colors.red,
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  _showDeleteConfirmation(
                                                      context, () {
                                                    taskprovider.DeleteTask(
                                                        task.id);
                                                  });
                                                },
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailTask(taskprovider
                                                            .GetTaskDetails(
                                                                task.id)),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox(height: 0);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          tooltip: 'Thêm',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    child: Edit(null, 0),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
