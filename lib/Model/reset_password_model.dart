import 'package:meta/meta.dart';
import 'dart:convert';

ResetPasswordModel resetPasswordModelFromJson(String str) => ResetPasswordModel.fromJson(json.decode(str));

String resetPasswordModelToJson(ResetPasswordModel data) => json.encode(data.toJson());

class ResetPasswordModel {
  final String status;
  final String message;

  ResetPasswordModel({
    required this.status,
    required this.message,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) => ResetPasswordModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
