import 'package:meta/meta.dart';
import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) => AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) => json.encode(data.toJson());

class AttendanceModel {
  final String status;
  final dynamic exception;
  final dynamic message;

  AttendanceModel({
    required this.status,
    required this.exception,
    required this.message,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    status: json["status"],
    exception: json["exception"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "exception": exception,
    "message": message,
  };
}