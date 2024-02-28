import 'package:meta/meta.dart';
import 'dart:convert';

UpdateApplicationModel updateApplicationModelFromJson(String str) => UpdateApplicationModel.fromJson(json.decode(str));

String updateApplicationModelToJson(UpdateApplicationModel data) => json.encode(data.toJson());

class UpdateApplicationModel {
  final String status;
  final Data data;
  final String message;

  UpdateApplicationModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory UpdateApplicationModel.fromJson(Map<String, dynamic> json) => UpdateApplicationModel(
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
  final dynamic status;

  Data({
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
