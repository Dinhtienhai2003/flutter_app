// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  static int count = 1;
  String id = count.toString();
  int uuTien;
  String ghiChu;
  DateTime? begin = DateTime.now();
  DateTime? end = null;

  //0 : đang chờ đợi
  //1: đã hoàn thành
  //2: trễ hạn
  bool? status = false;
  dynamic? imgHoanThanh;
  bool? isShow = true;
  Task({
    required this.uuTien,
    required this.ghiChu,
    this.end,
    this.status,
    this.imgHoanThanh,
    this.isShow,
  }) {
    this.isShow = true;
    count++;
  }

  Task copyWith({
    int? uuTien,
    String? ghiChu,
    DateTime? end,
    bool? status,
    dynamic? imgHoanThanh,
    bool? isShow,
  }) {
    return Task(
      uuTien: uuTien ?? this.uuTien,
      ghiChu: ghiChu ?? this.ghiChu,
      end: end ?? this.end,
      status: status ?? this.status,
      imgHoanThanh: imgHoanThanh ?? this.imgHoanThanh,
      isShow: isShow ?? this.isShow,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuTien': uuTien,
      'ghiChu': ghiChu,
      'end': end?.millisecondsSinceEpoch,
      'status': status,
      'imgHoanThanh': imgHoanThanh,
      'isShow': isShow,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      uuTien: map['uuTien'] as int,
      ghiChu: map['ghiChu'] as String,
      end: map['end'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end'] as int)
          : null,
      status: map['status'] != null ? map['status'] as bool : null,
      imgHoanThanh:
          map['imgHoanThanh'] != null ? map['imgHoanThanh'] as dynamic : null,
      isShow: map['isShow'] != null ? map['isShow'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(uuTien: $uuTien, ghiChu: $ghiChu, end: $end, status: $status, imgHoanThanh: $imgHoanThanh, isShow: $isShow)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.uuTien == uuTien &&
        other.ghiChu == ghiChu &&
        other.end == end &&
        other.status == status &&
        other.imgHoanThanh == imgHoanThanh &&
        other.isShow == isShow;
  }

  @override
  int get hashCode {
    return uuTien.hashCode ^
        ghiChu.hashCode ^
        end.hashCode ^
        status.hashCode ^
        imgHoanThanh.hashCode ^
        isShow.hashCode;
  }
}
