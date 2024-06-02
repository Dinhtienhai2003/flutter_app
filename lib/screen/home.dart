import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/model/task.dart';
import 'package:ontap_sharedprefences/screen/drawer.dart';
import 'package:provider/provider.dart';
import '../provider/setting.dart';
import '../provider/statustask.dart';
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
        backgroundColor: Colors.blue,
        title: Text(
          "Todo App",
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
              StreamBuilder<DateTime>(
                stream: context.read<TaskProvider>().timeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Consumer<TaskProvider>(
                      builder: (context, taskprovider, child) {
                        return Expanded(
                          child: Column(
                            children: [
                              taskprovider.getListTaskOverDue().length > 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Nhiệm vụ quá hạn",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                           
                                            IconButton(
                                                icon: context
                                                        .watch<
                                                            SettingProvider>()
                                                        .isGiam
                                                    ? Icon(
                                                        Icons.arrow_downward,
                                                        color: context
                                                                .watch<
                                                                    SettingProvider>()
                                                                .isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_upward,
                                                        color: context
                                                                .watch<
                                                                    SettingProvider>()
                                                                .isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                onPressed: () {
                                                  context
                                                      .read<SettingProvider>()
                                                      .setSort();
                                                })
                                          ],
                                        )
                                      ],
                                    )
                                  : SizedBox(height: 0),
                              taskprovider.getListTaskOverDue().length > 0
                                  ? Expanded(
                                      child: ListView.builder(
                                        itemCount: taskprovider
                                            .getListTaskOverDue()
                                            .length,
                                        itemBuilder: (context, index) {
                                          final task =
                                              taskprovider.GetListTask();
                                          if (context
                                              .watch<SettingProvider>()
                                              .isGiam) {
                                            task.sort((a, b) =>
                                                b.uuTien.compareTo(a.uuTien));
                                          } else {
                                            task.sort((a, b) =>
                                                a.uuTien.compareTo(b.uuTien));
                                          }

                                          return Card(
                                            child: ListTile(
                                              leading: Checkbox(
                                                checkColor: Colors.blue,
                                                activeColor: Colors.white,
                                                value: context
                                                    .watch<TaskProvider>()
                                                    .getStatusFromMap(
                                                        task[index].id),
                                                onChanged: (bool? value) {
                                                  taskprovider.SetStatus(
                                                      task[index].id, value!);
                                                },
                                              ),
                                              title: Text(
                                                "Ưu tiên : ${task[index].uuTien}",
                                                style: TextStyle(
                                                  color: task[index].uuTien < 3
                                                      ? Colors.red
                                                      : task[index].uuTien >
                                                                  2 &&
                                                              task[index]
                                                                      .uuTien <
                                                                  6
                                                          ? Colors.orange
                                                          : snapshot.data! ==
                                                                  true
                                                              ? Colors.grey
                                                              : null,
                                                  decoration:
                                                      snapshot.data! == true
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "Nội dung: " +
                                                    task[index].ghiChu,
                                                style: TextStyle(
                                                  decoration:
                                                      snapshot.data! == true
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                  color: snapshot.data! == true
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
                                                        task[index].id);
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
                                                                task[index]
                                                                    .id)),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(height: 0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nhiệm vụ hiện tại",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 16.0),
                                  Row(
                                    children: [
                                      
                                      IconButton(
                                          icon: context
                                                  .watch<SettingProvider>()
                                                  .isGiam
                                              ? Icon(
                                                  Icons.arrow_downward,
                                                  color: context
                                                          .watch<
                                                              SettingProvider>()
                                                          .isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                )
                                              : Icon(
                                                  Icons.arrow_upward,
                                                  color: context
                                                          .watch<
                                                              SettingProvider>()
                                                          .isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                          onPressed: () {
                                            context
                                                .read<SettingProvider>()
                                                .setSort();
                                          })
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Expanded(
                                  child: ListView.builder(
                                itemCount: taskprovider.GetListTask().length,
                                itemBuilder: (context, index) {
                                  final task = taskprovider.GetListTask();
                                  if (context.watch<SettingProvider>().isGiam) {
                                    task.sort(
                                        (a, b) => b.uuTien.compareTo(a.uuTien));
                                  } else {
                                    task.sort(
                                        (a, b) => a.uuTien.compareTo(b.uuTien));
                                  }
                                  return task[index].isShow == true
                                      ? Card(
                                          child: ListTile(
                                            leading: Checkbox(
                                              checkColor: Colors.blue,
                                              activeColor: Colors.white,
                                              value: context
                                                  .watch<TaskProvider>()
                                                  .getStatusFromMap(
                                                      task[index].id),
                                              onChanged: (bool? value) {
                                                taskprovider.SetStatus(
                                                    task[index].id, value!);
                                              },
                                            ),
                                            title: Text(
                                              "Ưu tiên " +
                                                  task[index].uuTien.toString(),
                                              style: TextStyle(
                                                color: task[index].uuTien < 3
                                                    ? Colors.red
                                                    : task[index].uuTien > 2 &&
                                                            task[index].uuTien <
                                                                6
                                                        ? Colors.orange
                                                        : snapshot.data! == true
                                                            ? Colors.grey
                                                            : null,
                                                decoration: snapshot.data! ==
                                                        true
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "Nội dung: " + task[index].ghiChu,
                                              style: TextStyle(
                                                decoration: snapshot.data! ==
                                                        true
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                color: snapshot.data! == true
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
                                                  taskprovider.DeleteTask(
                                                      task[index].id);
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
                                                              task[index].id)),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        );
                                },
                              )),
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
