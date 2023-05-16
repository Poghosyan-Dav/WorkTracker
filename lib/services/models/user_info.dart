// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:worktracker/services/models/user.dart';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));


class UserInfo {
  UserInfo({
    this.id,
     this.userId,
     this.status,
     this.date,
     this.startTime,
     this.endTime,
     this.startLocation,
     this.currentLocation,
     this.endLocation,
     this.user,
  });

  final int? id;
  final int? userId;
  final String? status;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final InfoLocation? startLocation;
  final dynamic currentLocation;
  final dynamic endLocation;
  final User? user;

  UserInfo copyWith({
    int? id,
    int? userId,
    String? status,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    InfoLocation? startLocation,
    dynamic currentLocation,
    dynamic endLocation,
    User? user,
  }) =>
      UserInfo(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        startLocation: startLocation ?? this.startLocation,
        currentLocation: currentLocation ?? this.currentLocation,
        endLocation: endLocation ?? this.endLocation,
        user: user ?? this.user,
      );

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    userId: json["user_id"],
    status: json["status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime:  json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    startLocation: json["start_location"] == null ? null : InfoLocation.fromJson(json["start_location"]),
    currentLocation: json["current_location"],
    endLocation: json["end_location"],
    user: json["user"]== null ? null :User.fromJson(json['user']) ,
  );


}

class InfoLocation {
  InfoLocation({
    @required this.lat,
    @required this.lng,
  });

  final String? lat;
  final String? lng;

  InfoLocation copyWith({
    String? lat,
    String? lng,
  }) =>
      InfoLocation(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory InfoLocation.fromJson(Map<String, dynamic> json) =>
      InfoLocation(
        lat: json["lat"],
        lng: json["lng"],
      );


}