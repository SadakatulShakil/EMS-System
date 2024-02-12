import 'package:meta/meta.dart';
import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  final String status;
  final Data data;
  final String message;

  AuthModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
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
  final String token;
  final int expiry;

  Data({
    required this.token,
    required this.expiry,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    expiry: json["expiry"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expiry": expiry,
  };
}
