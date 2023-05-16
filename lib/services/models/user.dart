// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'user_actions.dart';


User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.role,
    this.firstName,
    this.lastName,
    this.username,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.password,
  });

  int? id;
  String? role;
  String? firstName;
  String? lastName;
  String? username;
  String? password;
  dynamic location;
  dynamic createdAt;
  dynamic updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    role: json["role"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    location:json['location']!=null?UserLocation.fromJson(json["location"]):null,
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "location": location,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
