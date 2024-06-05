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
          "Todudu",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                activeColor: Colors.black12,
                activeTrackColor: Colors.black87,
                inactiveTrackColor: Colors.yellow,

                activeThumbImage: AssetImage(
                    'assets/night.png'), // Hình ảnh cho thumb khi hoạt động
                inactiveThumbImage: AssetImage(
                    'assets/sun.png'), // Hình ảnh cho thumb khi không hoạt động
                value: context.watch<SettingProvider>().isDark,
                onChanged: (newValue) {
                  context.read<SettingProvider>().setBrightness(newValue);
                },
              ),
              PopupMenuButton(
                iconSize: 30,
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Text("Tăng dần theo độ ưu tiên"),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_upward)
                        ],
                      ),
                      value: 'Sắp xếp tăng',
                      onTap: () {
                        context.read<SettingProvider>().sortUp();
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Text("Giảm dần theo độ ưu tiên"),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_downward)
                        ],
                      ),
                      value: 'Sắp xếp giảm',
                      onTap: () {
                        context.read<SettingProvider>().sortDown();
                      },
                    ),
                  ];
                },
                onSelected: (value) {
                  print('Selected: $value');
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<DateTime>(
              stream: context.read<TaskProvider>().timeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Consumer2<TaskProvider, SettingProvider>(
                    builder: (context, taskprovider, settingprovider, child) {
                      return Flexible(
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
                                    ],
                                  )
                                : SizedBox(height: 0),
                            taskprovider.getListTaskOverDue().length > 0
                                ? Container(
                                    height: taskprovider
                                            .getListTaskOverDue()
                                            .length *
                                        100.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: taskprovider
                                          .getListTaskOverDue()
                                          .length,
                                      itemBuilder: (context, index) {
                                        final task =
                                            taskprovider.getListTaskOverDue();

                                        return Card(
                                          child: ListTile(
                                            leading: Checkbox(
                                              checkColor: Colors.blue,
                                              activeColor: Colors.white,
                                              value:
                                                  taskprovider.getStatusFromMap(
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
                                                    : task[index].uuTien > 2 &&
                                                            task[index].uuTien <
                                                                6
                                                        ? Colors.orange
                                                        : taskprovider.getStatusFromMap(
                                                                    task[index]
                                                                        .id) ==
                                                                true
                                                            ? Colors.grey
                                                            : null,
                                                decoration: taskprovider
                                                            .getStatusFromMap(
                                                                task[index]
                                                                    .id) ==
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
                                                color: taskprovider
                                                            .getStatusFromMap(
                                                                task[index]
                                                                    .id) ==
                                                        true
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
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(height: 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Nhiệm vụ hiện tại",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 16.0),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Flexible(
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
                                            value:
                                                taskprovider.getStatusFromMap(
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
                                                          task[index].uuTien < 6
                                                      ? Colors.orange
                                                      : taskprovider.getStatusFromMap(
                                                                  task[index]
                                                                      .id) ==
                                                              true
                                                          ? Colors.grey
                                                          : null,
                                              decoration: taskprovider
                                                          .getStatusFromMap(
                                                              task[index].id) ==
                                                      true
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Nội dung: " + task[index].ghiChu,
                                            style: TextStyle(
                                              decoration: taskprovider
                                                          .getStatusFromMap(
                                                              task[index].id) ==
                                                      true
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              color:
                                                  taskprovider.getStatusFromMap(
                                                              task[index].id) ==
                                                          true
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
