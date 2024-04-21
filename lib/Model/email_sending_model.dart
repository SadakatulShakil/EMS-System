import 'dart:convert';

MailSendModel mailSendModelFromJson(String str) => MailSendModel.fromJson(json.decode(str));

String mailSendModelToJson(MailSendModel data) => json.encode(data.toJson());

class MailSendModel {
  final dynamic status;
  final dynamic message;

  MailSendModel({
    required this.status,
    required this.message,
  });

  factory MailSendModel.fromJson(Map<String, dynamic> json) => MailSendModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
