import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/provider/task.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';

class Edit extends StatefulWidget {
  Task? _Task;
  late DateTime _beginDate = DateTime.now();
  late DateTime? _endDate = _Task?.end;
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
  TextEditingController _uuTienController = TextEditingController();
  TextEditingController _ghiChuController = TextEditingController();
  TextEditingController _endController = TextEditingController();

  int _uuTien = 1;
  String _ghiChu = '';

  @override
  void initState() {
    super.initState();
    if (widget._Task != null) {
      _uuTien = widget._Task!.uuTien;
      _ghiChu = widget._Task!.ghiChu;
      widget._beginDate = widget._Task!.begin!;
      widget._endDate = widget._Task?.end != null ? widget._Task!.end! : null;
      _endController.text = widget._Task?.end != null
          ? DateFormat('dd-MM-yyyy HH:mm:ss').format(widget._Task!.end!)
          : "";
    }
  }

  void _onUuTienChanged(String value) {
    setState(() {
      _uuTien = int.parse(value);
    });
  }

  void _onGhiChuChanged(String value) {
    setState(() {
      _ghiChu = value;
    });
  }

  void _onBeginDateTimeChanged(DateTime dateTime) {
    setState(() {
      widget._beginDate = dateTime;
    });
  }

  void _onEndDateTimeChanged(DateTime dateTime) {
    setState(() {
      widget._endDate = dateTime;
      _endController.text = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
    });
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(Question),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                deleteFunction();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(Content),
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

  Future<void> _selectDateTime(
    BuildContext context,
    Function(DateTime) onDateTimeChanged,
  ) async {
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
        onDateTimeChanged(finalDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget._title ?? "Edit"),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _uuTien.toString(),
                keyboardType: TextInputType.number,
                onChanged: _onUuTienChanged,
                decoration: InputDecoration(
                  labelText: 'Ưu tiên',
                ),
              ),
              TextFormField(
                initialValue: _ghiChu,
                onChanged: _onGhiChuChanged,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                ),
              ),
              TextFormField(
                readOnly: true,
                onTap: () {
                  _selectDateTime(context, _onEndDateTimeChanged);
                },
                controller: _endController,
                decoration: InputDecoration(
                  labelText: 'Kết thúc',
                  //LỖI ~~~~~
                  // suffixIcon: IconButton(
                  //   icon: Icon(Icons.calendar_today),
                  //   onPressed: () {
                  //     _selectDateTime(context, _onEndDateTimeChanged);
                  //   },
                  // ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _showConfirmation(
                        context,
                        widget._mode == 0 ? 'Thêm' : 'Sửa',
                        "Thông tin Task đã được ${widget._mode == 0 ? 'thêm' : 'sửa'} thành công!",
                        "Bạn muốn ${widget._mode == 0 ? 'thêm' : 'lưu lại'} thông tin này ?",
                        () {
                          if (widget._mode == 0) {
                            context.read<TaskProvider>().AddTask(
                                _uuTien,
                                _ghiChu,
                                widget._beginDate,
                                widget._endDate == null
                                    ? null
                                    : DateFormat('dd-MM-yyyy HH:mm:ss')
                                        .parse(_endController.text));
                          } else {
                            context.read<TaskProvider>().UpdateTask(
                                  widget._Task!.id,
                                  _uuTien,
                                  _ghiChu,
                                  widget._beginDate,
                                  widget._endDate,
                                );
                          }
                          Navigator.pop(context);
                        },
                      );
                    });
                  }
                },
                child: Text('Lưu'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
