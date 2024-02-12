import 'package:meta/meta.dart';
import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  final String status;
  final Data data;
  final dynamic message;

  ProfileModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String department;
  final String designation;
  final String photo;
  final Attendance attendance;
  final Leave leave;
  final Settings settings;

  Data({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.department,
    required this.designation,
    required this.photo,
    required this.attendance,
    required this.leave,
    required this.settings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json["uuid"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    department: json["department"],
    designation: json["designation"],
    photo: json["photo"],
    attendance: Attendance.fromJson(json["attendance"]),
    leave: Leave.fromJson(json["leave"]),
    settings: Settings.fromJson(json["settings"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "address": address,
    "department": department,
    "designation": designation,
    "photo": photo,
    "attendance": attendance.toJson(),
    "leave": leave.toJson(),
    "settings": settings.toJson(),
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
  final String startTime;
  final String endTime;

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
