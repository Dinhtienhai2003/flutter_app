import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/provider/setting.dart';
import 'package:ontap_sharedprefences/provider/task.dart';
import 'package:ontap_sharedprefences/screen/Edit.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import 'detailtask.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _showDeleteConfirmation(
      BuildContext context, Function deleteFunction) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Người dùng phải chọn một hành động trước khi có thể thoát hộp thoại.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: Text('Bạn có muốn xóa không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại mà không thực hiện hành động xóa
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                deleteFunction();
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại sau khi thực hiện hành động xóa
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Xóa thành công!'),
                    duration: Duration(seconds: 2), // Thời gian hiển thị
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
        drawer: Drawer(child: Center(
          child:
              Consumer<TaskProvider>(builder: (context, taskprovider, child) {
            return Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Lịch sử thao tác",
                          style: TextStyle(fontSize: 25),
                        ),
                        FloatingActionButton(
                            backgroundColor: Colors.red,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                taskprovider.ClearLog();
                              },
                            ),
                            onPressed: () {
                              taskprovider.ClearLog();
                            }),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: taskprovider.GetLogs().length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(taskprovider.GetLogs()[index]),
                          ),
                        );
                      }),
                ),
              ],
            );
          }),
        )),
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
            child:
                Consumer<TaskProvider>(builder: (context, userprovider, child) {
              return ListView.builder(
                  itemCount: userprovider.GetListTask().length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          checkColor: Colors.blue,
                          activeColor: Colors.white,
                          value: userprovider.GetStatus(
                            userprovider.GetListTask()[index].id,
                          ),
                          onChanged: (bool? value) {
                            userprovider.SetStatus(
                                userprovider.GetListTask()[index].id, value!);
                          },
                        ),
                        title: Text(
                            "Ưu tiên :" +
                                userprovider.GetListTask()[index]
                                    .uuTien
                                    .toString(),
                            style: TextStyle(
                              decoration:
                                  userprovider.GetListTask()[index].status ==
                                          true
                                      ? TextDecoration.lineThrough
                                      : null,
                              color: userprovider.GetListTask()[index].status ==
                                      true
                                  ? Colors.grey
                                  : null,
                            )),
                        subtitle: Text(
                            "Nội Dung :" +
                                userprovider.GetListTask()[index].ghiChu,
                            style: TextStyle(
                              decoration:
                                  userprovider.GetListTask()[index].status ==
                                          true
                                      ? TextDecoration.lineThrough
                                      : null,
                              color: userprovider.GetListTask()[index].status ==
                                      true
                                  ? Colors.grey
                                  : null,
                            )),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmation(context, () {
                              userprovider.DeleteTask(
                                  userprovider.GetListTask()[index].id);
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailTask(
                                      userprovider.GetTaskDetails(
                                          userprovider.GetListTask()[index]
                                              .id))));
                        },
                      ),
                    );
                  });
            }),
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
                        // Cho phép người dùng cuộn nếu nội dung vượt quá kích thước màn hình
                        child: Edit(null, 0),
                      );
                    });
              }),
        ));
  }
}
