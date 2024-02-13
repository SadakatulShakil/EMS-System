import 'package:meta/meta.dart';
import 'dart:convert';

LeaveTypesModel leaveTypesModelFromJson(String str) => LeaveTypesModel.fromJson(json.decode(str));

String leaveTypesModelToJson(LeaveTypesModel data) => json.encode(data.toJson());

class LeaveTypesModel {
  final String status;
  final List<Datum> data;
  final dynamic message;

  LeaveTypesModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory LeaveTypesModel.fromJson(Map<String, dynamic> json) => LeaveTypesModel(
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
  final int id;
  final String name;

  Datum({
    required this.id,
    required this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
