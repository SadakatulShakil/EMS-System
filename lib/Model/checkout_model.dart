import 'package:meta/meta.dart';
import 'dart:convert';

CheckOutModel checkOutModelFromJson(String str) => CheckOutModel.fromJson(json.decode(str));

String checkOutModelToJson(CheckOutModel data) => json.encode(data.toJson());

class CheckOutModel {
  final String status;
  final Data data;
  final String message;

  CheckOutModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CheckOutModel.fromJson(Map<String, dynamic> json) => CheckOutModel(
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
  final DateTime checkout;

  Data({
    required this.checkout,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    checkout: DateTime.parse(json["checkout"]),
  );

  Map<String, dynamic> toJson() => {
    "checkout": checkout.toIso8601String(),
  };
}
