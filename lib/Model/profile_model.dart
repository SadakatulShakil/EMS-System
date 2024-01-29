// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

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
  final User user;
  final List<District> states;
  final List<District> regions;
  final List<District> districts;
  final dynamic village;

  Data({
    required this.user,
    required this.states,
    required this.regions,
    required this.districts,
    required this.village,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    states: List<District>.from(json["states"].map((x) => District.fromJson(x))),
    regions: List<District>.from(json["regions"].map((x) => District.fromJson(x))),
    districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
    village: json["village"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "states": List<dynamic>.from(states.map((x) => x.toJson())),
    "regions": List<dynamic>.from(regions.map((x) => x.toJson())),
    "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
    "village": village,
  };
}

class District {
  final int id;
  final String name;
  final Region region;
  final String code;
  final Region state;

  District({
    required this.id,
    required this.name,
    required this.region,
    required this.code,
    required this.state,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"],
    name: json["name"],
    region: Region.fromJson(json["region"]),
    code: json["code"],
    state: Region.fromJson(json["state"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "region": region.toJson(),
    "code": code,
    "state": state.toJson(),
  };
}

class Region {
  final int id;
  final int stateId;
  final String nameEn;
  final String nameNt;
  final String code;
  final int population;
  final String lat;
  final String lon;
  final int status;

  Region({
    required this.id,
    required this.stateId,
    required this.nameEn,
    required this.nameNt,
    required this.code,
    required this.population,
    required this.lat,
    required this.lon,
    required this.status,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json["id"],
    stateId: json["state_id"],
    nameEn: json["name_en"],
    nameNt: json["name_nt"],
    code: json["code"],
    population: json["population"],
    lat: json["lat"],
    lon: json["lon"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state_id": stateId,
    "name_en": nameEn,
    "name_nt": nameNt,
    "code": code,
    "population": population,
    "lat": lat,
    "lon": lon,
    "status": status,
  };
}

class User {
  final int id;
  final String name;
  final String email;
  final String username;
  final String state;
  final String region;
  final String district;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.state,
    required this.region,
    required this.district,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    username: json["username"],
    state: json["state"],
    region: json["region"],
    district: json["district"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "username": username,
    "state": state,
    "region": region,
    "district": district,
  };
}
