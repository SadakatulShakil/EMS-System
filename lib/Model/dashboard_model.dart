// To parse this JSON data, do
//
//     final dashBoardModel = dashBoardModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) => DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  final String status;
  final Data data;
  final dynamic message;

  DashBoardModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  final ReportData reportData;
  final List<Attendance> attendance;
  final List<Leaf> leaves;

  Data({
    required this.reportData,
    required this.attendance,
    required this.leaves,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reportData: ReportData.fromJson(json["report_data"]),
    attendance: List<Attendance>.from(json["attendance"].map((x) => Attendance.fromJson(x))),
    leaves: List<Leaf>.from(json["leaves"].map((x) => Leaf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "report_data": reportData.toJson(),
    "attendance": List<dynamic>.from(attendance.map((x) => x.toJson())),
    "leaves": List<dynamic>.from(leaves.map((x) => x.toJson())),
  };
}

class Attendance {
  final String name;
  final String email;
  final String phone;
  final dynamic photo;
  final String designation;
  final String department;
  final dynamic checkin;
  final dynamic checkout;
  final dynamic lateReason;
  final int totalHours;
  final int status;

  Attendance({
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.designation,
    required this.department,
    required this.checkin,
    required this.checkout,
    required this.lateReason,
    required this.totalHours,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    photo: json["photo"],
    designation: json["designation"],
    department: json["department"],
    checkin: json["checkin"],
    checkout: json["checkout"],
    lateReason: json["late_reason"],
    totalHours: json["total_hours"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "photo": photo,
    "designation": designation,
    "department": department,
    "checkin": checkin,
    "checkout": checkout,
    "late_reason": lateReason,
    "total_hours": totalHours,
    "status": status,
  };
}

class Leaf {
  final String name;
  final String email;
  final String phone;
  final dynamic photo;
  final String designation;
  final String reason;
  final DateTime from;
  final DateTime to;
  final String status;

  Leaf({
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.designation,
    required this.reason,
    required this.from,
    required this.to,
    required this.status,
  });

  factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    photo: json["photo"],
    designation: json["designation"],
    reason: json["reason"],
    from: DateTime.parse(json["from"]),
    to: DateTime.parse(json["to"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "photo": photo,
    "designation": designation,
    "reason": reason,
    "from": "${from.year.toString().padLeft(4, '0')}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}",
    "to": "${to.year.toString().padLeft(4, '0')}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}",
    "status": status,
  };
}

class ReportData {
  final int attendance;
  final int leave;

  ReportData({
    required this.attendance,
    required this.leave,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
    attendance: json["attendance"],
    leave: json["leave"],
  );

  Map<String, dynamic> toJson() => {
    "attendance": attendance,
    "leave": leave,
  };
}
