import 'package:meta/meta.dart';
import 'dart:convert';

LeaveApplicationsModel leaveApplicationsModelFromJson(String str) => LeaveApplicationsModel.fromJson(json.decode(str));

String leaveApplicationsModelToJson(LeaveApplicationsModel data) => json.encode(data.toJson());

class LeaveApplicationsModel {
  final String status;
  final List<Datum> data;
  final String message;

  LeaveApplicationsModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory LeaveApplicationsModel.fromJson(Map<String, dynamic> json) => LeaveApplicationsModel(
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
  final int leaveId;
  final String employee;
  final String reason;
  final String type;
  final DateTime startedAt;
  final DateTime endedAt;
  final String status;

  Datum({
    required this.leaveId,
    required this.employee,
    required this.reason,
    required this.type,
    required this.startedAt,
    required this.endedAt,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    leaveId: json["leave_id"],
    employee: json["employee"],
    reason: json["reason"],
    type: json["type"],
    startedAt: DateTime.parse(json["started_at"]),
    endedAt: DateTime.parse(json["ended_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "leave_id": leaveId,
    "employee": employee,
    "reason": reason,
    "type": type,
    "started_at": "${startedAt.year.toString().padLeft(4, '0')}-${startedAt.month.toString().padLeft(2, '0')}-${startedAt.day.toString().padLeft(2, '0')}",
    "ended_at": "${endedAt.year.toString().padLeft(4, '0')}-${endedAt.month.toString().padLeft(2, '0')}-${endedAt.day.toString().padLeft(2, '0')}",
    "status": status,
  };
}
