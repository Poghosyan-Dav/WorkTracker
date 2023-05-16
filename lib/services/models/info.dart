// To parse this JSON data, do
//
//     final infoUser = infoUserFromJson(jsonString);

import 'dart:convert';

import 'package:worktracker/services/models/user.dart';

class InfoUser {
  final int? currentPage;
  final List<Datum>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  InfoUser({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory InfoUser.fromRawJson(String str) => InfoUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InfoUser.fromJson(Map<String, dynamic> json) => InfoUser(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  final int? id;
  final int? userId;
  final dynamic status;
  final DateTime? date;
  final Location? startLocation;
  final Location? currentLocation;
  final Location? endLocation;
  final List<Time>? times;
  final String? duration;
  final User? user;

  Datum({
    this.id,
    this.userId,
    this.status,
    this.date,
    this.startLocation,
    this.currentLocation,
    this.endLocation,
    this.times,
    this.duration,
    this.user,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    status: json["status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    startLocation: json["start_location"] == null ? null : Location.fromJson(json["start_location"]),
    currentLocation: json["current_location"] == null ? null : Location.fromJson(json["current_location"]),
    endLocation: json["end_location"] == null ? null : Location.fromJson(json["end_location"]),
    times: json["times"] == null ? [] : List<Time>.from(json["times"]!.map((x) => Time.fromJson(x))),
    duration: json["duration"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "status": status,
    "date": date?.toIso8601String(),
    "start_location": startLocation?.toJson(),
    "current_location": currentLocation?.toJson(),
    "end_location": endLocation?.toJson(),
    "times": times == null ? [] : List<dynamic>.from(times!.map((x) => x.toJson())),
    "duration": duration,
    "user": user?.toJson(),
  };
}

class Location {
  final String? lat;
  final String? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Time {
  final String? end;
  final String? start;

  Time({
    this.end,
    this.start,
  });

  factory Time.fromRawJson(String str) => Time.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    end: json["end"],
    start: json["start"],
  );

  Map<String, dynamic> toJson() => {
    "end": end,
    "start": start,
  };
}

// class User {
//   final int? id;
//   final String? role;
//   final String? firstName;
//   final String? lastName;
//   final String? username;
//   final dynamic location;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   User({
//     this.id,
//     this.role,
//     this.firstName,
//     this.lastName,
//     this.username,
//     this.location,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     role: json["role"],
//     firstName: json["first_name"],
//     lastName: json["last_name"],
//     username: json["username"],
//     location: json["location"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "role": role,
//     "first_name": firstName,
//     "last_name": lastName,
//     "username": username,
//     "location": location,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//   };
// }

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
