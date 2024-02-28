import 'package:meta/meta.dart';
import 'dart:convert';

LeaveHistoryModel leaveHistoryModelFromJson(String str) => LeaveHistoryModel.fromJson(json.decode(str));

String leaveHistoryModelToJson(LeaveHistoryModel data) => json.encode(data.toJson());

class LeaveHistoryModel {
  final String status;
  final Data data;
  final String message;

  LeaveHistoryModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) => LeaveHistoryModel(
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
  final int total;
  final List<Detail> details;

  Data({
    required this.total,
    required this.details,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Detail {
  final String type;
  final String reason;
  final DateTime startedAt;
  final DateTime endedAt;
  final String status;

  Detail({
    required this.type,
    required this.reason,
    required this.startedAt,
    required this.endedAt,
    required this.status,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    type: json["type"],
    reason: json["reason"],
    startedAt: DateTime.parse(json["started_at"]),
    endedAt: DateTime.parse(json["ended_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "reason": reason,
    "started_at": "${startedAt.year.toString().padLeft(4, '0')}-${startedAt.month.toString().padLeft(2, '0')}-${startedAt.day.toString().padLeft(2, '0')}",
    "ended_at": "${endedAt.year.toString().padLeft(4, '0')}-${endedAt.month.toString().padLeft(2, '0')}-${endedAt.day.toString().padLeft(2, '0')}",
    "status": status,
  };
}
