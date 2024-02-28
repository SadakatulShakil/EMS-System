import 'package:meta/meta.dart';
import 'dart:convert';

AttendanceHistoryModel attendanceHistoryModelFromJson(String str) => AttendanceHistoryModel.fromJson(json.decode(str));

String attendanceHistoryModelToJson(AttendanceHistoryModel data) => json.encode(data.toJson());

class AttendanceHistoryModel {
  final String status;
  final List<Datum> data;
  final String message;

  AttendanceHistoryModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) => AttendanceHistoryModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  final DateTime checkin;
  final String checkout;
  final String lateReason;

  Datum({
    required this.checkin,
    required this.checkout,
    required this.lateReason,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    checkin: DateTime.parse(json["checkin"]),
    checkout: json["checkout"],
    lateReason: json["late_reason"],
  );

  Map<String, dynamic> toJson() => {
    "checkin": checkin.toIso8601String(),
    "checkout": checkout,
    "late_reason": lateReason,
  };
}
