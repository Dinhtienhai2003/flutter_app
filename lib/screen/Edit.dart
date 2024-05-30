import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/provider/task.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';

class Edit extends StatefulWidget {
  Task? _Task;
  late DateTime _beginDate = DateTime.now();

  late DateTime _endDate = DateTime.now();
  int? _mode;
  String? _title;
  Edit(Task? Task, int mode) {
    _Task = Task;
    _mode = mode;

    // mode = 0 -> thêm
    // mode = 1 -> sửa
    // mode = 2 -> xóa

    if (mode == 0) {
      _title = "Thêm";
    } else if (mode == 1) {
      _title = "Sửa";
    } else if (mode == 2) {
      _title = "Xóa";
    } else {
      _title = "Edit";
    }
  }

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerUuTien = TextEditingController();
  final TextEditingController _controllerGhiChu = TextEditingController();
  final TextEditingController _controllerBegin = TextEditingController();
  final TextEditingController _controllerEnd = TextEditingController();

  void initState() {
    super.initState();
  }

  Future<void> _showConfirmation(
    BuildContext context,
    String title,
    String Content,
    String Question,
    Function deleteFunction,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Người dùng phải chọn một hành động trước khi có thể thoát hộp thoại.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(Question),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại mà không thực hiện hành động xóa
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                deleteFunction();
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại sau khi thực hiện hành động xóa
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(Content),
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

  Future<void> _selectDateTime(TextEditingController controller) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
      );
      if (time != null) {
        final DateTime finalDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        controller.text =
            DateFormat('dd-MM-yyy HH:mm:ss').format(finalDateTime);
        if (controller == _controllerBegin) {
          widget._beginDate = finalDateTime;
        } else if (controller == _controllerEnd) {
          widget._endDate = finalDateTime;
        }
      }
    }
  }

  String? _validateUuTien(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mức độ ưu tiên.';
    }
    // Kiểm tra xem giá trị có phải là số hay không
    if (double.tryParse(value) == null) {
      return 'Vui lòng nhập một số.';
    }
    // Thêm các điều kiện validate khác nếu cần
    return null;
  }

  String? _validateGhiChu(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập nội dung';
    }
    // Thêm các điều kiện validate khác nếu cần
    return null;
  }

  String? _validateBegin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập thời gian bắt đầu.';
    }
    if (widget._beginDate.isBefore(DateTime.now())) {
      return 'Thời gian begin la ${widget._beginDate} bắt đầu không thể nhỏ hơn thời gian hiện tại.';
    }
    return null;
  }

  String? _validateEnd(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập thời gian kết thúc.';
    }
    if (widget._endDate.isBefore(widget._beginDate)) {
      return 'Thời gian end là ${widget._endDate} kết thúc  không thể nhỏ hơn thời gian bắt đầu.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _controllerUuTien.text =
        widget._Task == null ? "" : widget._Task!.id.toString();
    _controllerGhiChu.text =
        widget._Task == null ? "" : widget._Task!.ghiChu.toString();
    _controllerBegin.text = widget._Task == null
        ? DateFormat('dd-MM-yyy HH:mm:ss').format(DateTime.now())
        : DateFormat('dd-MM-yyy HH:mm:ss').format(widget._Task!.begin);
    _controllerEnd.text = widget._Task == null
        ? DateFormat('dd-MM-yyy HH:mm:ss').format(DateTime.now())
        : DateFormat('dd-MM-yyy HH:mm:ss').format(widget._Task!.end);
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget._title ?? "Edit"),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controllerUuTien,
              decoration: InputDecoration(
                labelText: 'Ưu tiên',
              ),
              validator: _validateUuTien,
            ),
            TextFormField(
              controller: _controllerGhiChu,
              decoration: InputDecoration(
                labelText: 'Ghi chú',
              ),
              validator: _validateGhiChu,
            ),
            TextFormField(
              readOnly: true,
              controller: _controllerBegin,
              decoration: InputDecoration(
                labelText: 'Bắt đầu',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDateTime(_controllerBegin);
                  },
                ),
              ),
              validator: _validateBegin,
            ),
            TextFormField(
              readOnly: true,
              controller: _controllerEnd,
              decoration: InputDecoration(
                labelText: 'Kết thúc',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDateTime(_controllerEnd);
                  },
                ),
              ),
              validator: _validateEnd,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (widget._mode == 0) {
                    print("dang nhan them");
                    _showConfirmation(
                        context,
                        'Thêm',
                        "Thông tin Task đã được thêm thành công!",
                        "Bạn muốn thêm thông tin này ?", () {
                      if (_formKey.currentState!.validate()) {
                        context.read<TaskProvider>().AddTask(
                            int.parse(_controllerUuTien.text),
                            _controllerGhiChu.text,
                            widget._beginDate,
                            widget._endDate);

                        Navigator.pop(context);
                      }
                    });
                  } else {
                    _showConfirmation(
                        context,
                        'Sửa',
                        "Thông tin Task đã được sửa thành công!",
                        "Bạn muốn lưu lại thông tin này ?", () {
                      if (_formKey.currentState!.validate()) {
                        context.read<TaskProvider>().UpdateTask(
                            widget._Task!.id,
                            int.parse(_controllerUuTien.text),
                            _controllerGhiChu.text,
                            widget._beginDate,
                            widget._endDate);

                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: Text("Lưu"))
          ],
        ),
      ),
    );
  }
}
