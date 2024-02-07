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
  final User user;
  final Attendance attendance;
  final Leave leave;
  final Settings settings;
  final String token;
  final int expiry;

  Data({
    required this.user,
    required this.attendance,
    required this.leave,
    required this.settings,
    required this.token,
    required this.expiry,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    attendance: Attendance.fromJson(json["attendance"]),
    leave: Leave.fromJson(json["leave"]),
    settings: Settings.fromJson(json["settings"]),
    token: json["token"],
    expiry: json["expiry"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "attendance": attendance.toJson(),
    "leave": leave.toJson(),
    "settings": settings.toJson(),
    "token": token,
    "expiry": expiry,
  };
}

class Attendance {
  final int workingDays;
  final int onTime;
  final int lateTime;

  Attendance({
    required this.workingDays,
    required this.onTime,
    required this.lateTime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    workingDays: json["workingDays"],
    onTime: json["onTime"],
    lateTime: json["lateTime"],
  );

  Map<String, dynamic> toJson() => {
    "workingDays": workingDays,
    "onTime": onTime,
    "lateTime": lateTime,
  };
}

class Leave {
  final int total;
  final int used;

  Leave({
    required this.total,
    required this.used,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
    total: json["total"],
    used: json["used"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "used": used,
  };
}

class Settings {
  final Office office;

  Settings({
    required this.office,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    office: Office.fromJson(json["office"]),
  );

  Map<String, dynamic> toJson() => {
    "office": office.toJson(),
  };
}

class Office {
  final int startTime;
  final int endTime;

  Office({
    required this.startTime,
    required this.endTime,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
  };
}

class User {
  final String uuid;
  final String name;
  final String email;
  final String photo;
  final String designation;

  User({
    required this.uuid,
    required this.name,
    required this.email,
    required this.photo,
    required this.designation,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    uuid: json["uuid"],
    name: json["name"],
    email: json["email"],
    photo: json["photo"],
    designation: json["designation"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "email": email,
    "photo": photo,
    "designation": designation,
  };
}