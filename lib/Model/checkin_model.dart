import 'package:meta/meta.dart';
import 'dart:convert';

CheckInModel checkInModelFromJson(String str) => CheckInModel.fromJson(json.decode(str));

String checkInModelToJson(CheckInModel data) => json.encode(data.toJson());

class CheckInModel {
  final String status;
  final Data data;
  final String message;

  CheckInModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) => CheckInModel(
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
  final DateTime checkin;

  Data({
    required this.checkin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    checkin: DateTime.parse(json["checkin"]),
  );

  Map<String, dynamic> toJson() => {
    "checkin": checkin.toIso8601String(),
  };
}
