

import 'dart:convert';

UserActions userActionsFromJson(String str) => UserActions.fromJson(json.decode(str));


class UserActions {
  UserActions({
    this.type,
    this.time,
    this.location,
  });

  String? type;
  String? time;
  UserLocation? location;

  factory UserActions.fromJson(Map<String, dynamic> json) => UserActions(
    type: json["type"],
    time: json["time"],
    location: UserLocation.fromJson(json["location"]),
  );
}

class UserLocation {
  UserLocation({
    this.lat,
    this.lng,
  });

  String? lat;
  String? lng;

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
    lat: json["lat"],
    lng: json["lng"],
  );


}
