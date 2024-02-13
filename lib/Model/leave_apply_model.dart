import 'package:meta/meta.dart';
import 'dart:convert';

LeaveApplyModel leaveApplyModelFromJson(String str) => LeaveApplyModel.fromJson(json.decode(str));

String leaveApplyModelToJson(LeaveApplyModel data) => json.encode(data.toJson());

class LeaveApplyModel {
  final String status;
  final dynamic exception;
  final dynamic message;

  LeaveApplyModel({
    required this.status,
    required this.exception,
    required this.message,
  });

  factory LeaveApplyModel.fromJson(Map<String, dynamic> json) => LeaveApplyModel(
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
