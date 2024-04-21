import 'dart:convert';

OtpVerifyModel otpVerifyModelFromJson(String str) => OtpVerifyModel.fromJson(json.decode(str));

String otpVerifyModelToJson(OtpVerifyModel data) => json.encode(data.toJson());

class OtpVerifyModel {
  final String status;
  final String message;

  OtpVerifyModel({
    required this.status,
    required this.message,
  });

  factory OtpVerifyModel.fromJson(Map<String, dynamic> json) => OtpVerifyModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
