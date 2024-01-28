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
  final int expireAt;
  final User user;

  Data({
    required this.token,
    required this.expireAt,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    expireAt: json["expire_at"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expire_at": expireAt,
    "user": user.toJson(),
  };
}

class User {
  final String name;
  final String email;
  final String role;

  User({
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "role": role,
  };
}
