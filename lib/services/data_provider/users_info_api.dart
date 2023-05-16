import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:worktracker/services/data_provider/session_data_providers.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';
import 'package:worktracker/services/models/user_info.dart';

import '../../base_data/base_api.dart';
import '../models/user_actions.dart';
class UserActionsProvider {
  final sessionDataProvider = SessionDataProvider();
  final _userdataProvider = UserDataProvider();
  Future<bool?> fetchUserActions(UserActions userActions)async{
    final accessToken = await sessionDataProvider.readsAccessToken();
    Map<String,dynamic> userData = {
      "type": "${userActions.type}",
      "time":"${userActions.time}",
      "location": {
        "lat":"${userActions.location?.lat}",
        "lng":"${userActions.location?.lng}"
      }
    };


    try {
      var response = await http.post(
        Uri.parse(Api.startAndEndActions),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Bearer $accessToken'
        },
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        return true;
      } else if ( response.statusCode == 401) {
        bool isTrue = await _userdataProvider.refresh();

        if (isTrue) {
          return await fetchUserActions(userActions); // Call saveFavorite recursively after refreshing token
        } else {
          return false;
        }
      }  else {
        return false;
      }

    } catch (e) {
      debugPrint('$e');

    }
    return false;

  }
  Future<bool?> updateLocation(UserLocation location)async{
    var accTk = sessionDataProvider.readsAccessToken();
    Map userData = {
      'location': location,
    };
    //var refTk = sessionDataProvider.readRefreshToken();

    try {
      var response = await http.post(
        Uri.parse(Api.updateLocation),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Bearer $accTk'
        },
        body: json.encode(userData),
      );
      var body = jsonDecode(response.body);
      //var token = body['access_token'];
      // sessionDataProvider.deleteAllToken();
      if (response.statusCode == 200) {
        debugPrint('$body');
        return true;
      }  else if ( response.statusCode == 401) {
        bool isTrue = await _userdataProvider.refresh();

        if (isTrue) {
          return await updateLocation(location); // Call saveFavorite recursively after refreshing token
        } else {
          return false;
        }
      }  else {
        return false;
      }
    } catch (e) {
      debugPrint('$e');

    }
    return false;

  }
  Future<UserInfo?> getInfo(String id) async {
    var users =  UserInfo();
    var response = await http.get(
      Uri.parse(Api.getInfo(id)),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    try {
      var body = json.decode(response.body);

      var success = body['success'];
      if (success == true) {
        var content = body['data'];

        return UserInfo.fromJson(content);
      } else {
        return users;
      }
    } catch (e) {
      debugPrint('$e');

    }
    return users;
  }
  Future<void> logout()async{
    sessionDataProvider.deleteAllToken();
   await http.post(
      Uri.parse(Api.logout),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
  }
}