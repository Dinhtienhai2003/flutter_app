// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  static int count = 1;
  String id = count.toString();
  int uuTien;
  String ghiChu;
  DateTime begin;
  DateTime end;

  //0 : đang chờ đợi
  //1: đã hoàn thành
  //2: trễ hạn
  bool? status = false;
  dynamic? imgHoanThanh;
  Task({
    required this.uuTien,
    required this.ghiChu,
    required this.begin,
    required this.end,
    this.status,
    this.imgHoanThanh,
  }) {
    count++;
  }

  Task copyWith({
    int? uuTien,
    String? ghiChu,
    DateTime? begin,
    DateTime? end,
    bool? status,
    dynamic? imgHoanThanh,
  }) {
    return Task(
      uuTien: uuTien ?? this.uuTien,
      ghiChu: ghiChu ?? this.ghiChu,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      status: status ?? this.status,
      imgHoanThanh: imgHoanThanh ?? this.imgHoanThanh,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuTien': uuTien,
      'ghiChu': ghiChu,
      'begin': begin.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'status': status,
      'imgHoanThanh': imgHoanThanh,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      uuTien: map['uuTien'] as int,
      ghiChu: map['ghiChu'] as String,
      begin: DateTime.fromMillisecondsSinceEpoch(map['begin'] as int),
      end: DateTime.fromMillisecondsSinceEpoch(map['end'] as int),
      status: map['status'] != null ? map['status'] as bool : null,
      imgHoanThanh:
          map['imgHoanThanh'] != null ? map['imgHoanThanh'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(uuTien: $uuTien, ghiChu: $ghiChu, begin: $begin, end: $end, status: $status, imgHoanThanh: $imgHoanThanh)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.uuTien == uuTien &&
        other.ghiChu == ghiChu &&
        other.begin == begin &&
        other.end == end &&
        other.status == status &&
        other.imgHoanThanh == imgHoanThanh;
  }

  @override
  int get hashCode {
    return uuTien.hashCode ^
        ghiChu.hashCode ^
        begin.hashCode ^
        end.hashCode ^
        status.hashCode ^
        imgHoanThanh.hashCode;
  }
}
