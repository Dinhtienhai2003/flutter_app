import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/provider/task.dart';
import 'package:ontap_sharedprefences/screen/Edit.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';
import '../provider/setting.dart';

class DetailTask extends StatelessWidget {
  final Task? _task;
  const DetailTask(this._task, {super.key});

  Future<void> _showConfirmation(
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
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      // builder là một hàm xây dựng được gọi bất cứ khi nào pSinhViens thay đổi.
      builder: (context, pTask, child) {
        // Lấy thông tin sinh viên mới nhất từ danh sách
        Task? updatedTask = pTask.GetListTask().firstWhere(
          (Task) => Task.id == _task!.id,
          orElse: () => _task!,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Chi tiết task",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    context.watch<SettingProvider>().isDark
                        ? Icon(Icons.nightlight_round, color: Colors.black)
                        : Icon(Icons.wb_sunny, color: Colors.yellow),
                    Switch(
                      value: context.watch<SettingProvider>().isDark,
                      onChanged: (newValue) {
                        context.read<SettingProvider>().setBrightness(newValue);
                      },
                      activeColor: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(child: Edit(_task, 1));
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context.read<TaskProvider>().DeleteTask(_task!.id);

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),

                Text(
                  "Nội dung : " + updatedTask.ghiChu,
                  style: TextStyle(fontSize: 25),
                ), //
                SizedBox(height: 20),
                Text(
                    style: TextStyle(fontSize: 25),
                    "Bắt đầu : " +
                        DateFormat('dd-MM-yyy HH:mm:ss')
                            .format(updatedTask.begin ?? DateTime.now())), //

                SizedBox(height: 20),
                Text(
                    style: TextStyle(fontSize: 25),
                    updatedTask.end == null
                        ? "Kết thúc"
                        : "Kết thúc " +
                            DateFormat('dd-MM-yyy HH:mm:ss')
                                .format(updatedTask.end!)),
                SizedBox(height: 20),
                Text(style: TextStyle(fontSize: 25), "Anh hoan thanh"), //
              ],
            ),
          ),
        );
      },
    );
  }
}
