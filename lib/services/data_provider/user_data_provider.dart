import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';

import '../../base_data/base_api.dart';
import '../models/info.dart';
import '../models/user.dart';
import '../models/user_info.dart';

class UserDataProvider {
  Client client = Client();

  final sessionDataProvider = SessionDataProvider();
  bool isTrue = false;

  static const maxAccesSeconds = 3600;

  static const maxRefreshSeconds = 216000000;
  int seconds = maxAccesSeconds;
  bool isAccesTokenTimerActive = false;
  bool isRefreshTokenTimerActive = false;

  get isDarkMode => null;

  void startAccessTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer.cancel();
        isAccesTokenTimerActive = true;

      }
    });
  }

  void startRefreshTimer() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer.cancel();
        isRefreshTokenTimerActive = true;

      }
    });
  }


  //Sign Up
  Future<String> signUp(
      {required String userName,
        required String password,
        required  String firstName,required String lastName,required String role}) async {
    String isSuscces = '';

    isSuscces = await createUserWithNAmeEmailAndPassword(
        userName: userName, password: password, firstName: firstName,lastName: lastName,role:role);

    return isSuscces;
  }



  //Log out
  Future<void> logOut() async {
    try {
      await sessionDataProvider.deleteAllToken();
    } catch (e) {
      debugPrint('$e');

    }
  }

  //Login
  Future<Map<String,dynamic>?>? signInWithEmailAndPassword(
      {String? userName, String? password}) async {

    Map userData = {
      'username': userName,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(Api.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      var body = jsonDecode(response.body);
      var status = body['status'];
      var data = body['data'];

      if (response.statusCode == 200 && status == true) {
        var accessToken = data['access_token'];
        var refreshToken = data['refresh_token'];
        var role = data['is_user'];
        sessionDataProvider.setAccessToken(accessToken);
        sessionDataProvider.setRole(role.toString());
        sessionDataProvider.setRefreshToken(refreshToken);
        return data;
      } else {
        return body;
      }
    } catch (e) {
      debugPrint('$e');

    }
    return {};
  }

  //Signup
  Future<String> createUserWithNAmeEmailAndPassword(
      {String? userName, String? password, String? firstName, String? lastName, String? role}
      ) async {

    Map userData = {
      'first_name': firstName ?? '',
      'last_name': lastName ?? '',
      'password': password ?? '',
      'username': userName ?? '',
      'role': role ?? '',
    };

    try {
      var response = await http.post(
        Uri.parse(Api.createUsers),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );
      var body = jsonDecode(response.body);
      var status = body['status'];
      if (status == true) {
       var role =  body['data']['role'];
         sessionDataProvider.setRole(role);
        return ''; // Return an empty string to indicate success
      } else {
        var errorMessage = body['message'];
        return errorMessage; // Return the error message
      }
    } catch (e) {
      debugPrint('$e');
      return 'An error occurred while creating the user.'; // Return a generic error message
    }
  }




  Future<bool> refresh() async {
    final refreshToken = await sessionDataProvider.readRefreshToken();
    final accessToken = await sessionDataProvider.readsAccessToken();
    if (refreshToken != null) {
      try {
        final client = http.Client();
        final response = await client.post(Uri.parse(Api.refresh),
            headers: {
              'Authorization': 'bearer $accessToken',
              'Content-Type': "application/json",
            },
            body: <String, dynamic>{'refresh_token': refreshToken}).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);
          var newAccessToken = body['access_token'];
          if (newAccessToken == null) {
            // Invalid response, handle error
            debugPrint('Invalid response body: $body');
            return false;
          }
          sessionDataProvider.setAccessToken(newAccessToken);
          return true;
        } else if (response.statusCode == 401) {
          // Unauthorized, token expired or invalid
          var body = jsonDecode(response.body);
          if (body['error'] == 'invalid_grant') {
            // Refresh token expired or invalid, prompt user to log in again
            sessionDataProvider.deleteAllToken();
          } else {
            // Access token expired or invalid, refresh token still valid, try again
            await Future.delayed(const Duration(seconds: 5)); // Wait for 5 seconds before retrying
            return await refresh();
          }
        } else {
          // Other error, handle appropriately
          debugPrint('Request failed with status code: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        // Network or server error, handle appropriately
        debugPrint('Request failed: $e');
        return false;
      }
    }
    return false;
  }

  Future<Map> updateMyAccountFromApi({firstName, lastName, userName,role,password,id}) async {
    var token = await sessionDataProvider.readsAccessToken();

    if (token == null) {
      // Access token is not available, cannot make the request
      return {
        'errors': {
          'network': 'Access token not available'
        }
      };
    }
    final requestBody = {};

    if (firstName != null && firstName != '') {
      requestBody["first_name"] = firstName;
    }

    if (lastName != null && lastName != '') {
      requestBody["last_name"] = lastName;
    }

    if (userName != null && userName != '') {
      requestBody["username"] = userName;
    }
    if (password != null && password != '' )  {
      requestBody["password"] = password;
    }
    if (role != null && role != '' ) {
      requestBody["role"] = role;
    }
    try {
      final client = http.Client();
      final response = await client.post(
          Uri.parse(Api.updateUser(id)),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          body: requestBody
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        // Unauthorized, token expired or invalid
        final refreshed = await refresh();
        if (refreshed) {
          // Token refreshed successfully, retry the request
          return await updateMyAccountFromApi(
              firstName: firstName,
              lastName: lastName,
              userName: userName,
              password: password,
              role: role,
              id: id
          );
        } else {
          // Token refresh failed, prompt user to log in again
          sessionDataProvider.deleteAllToken();
          return {
            'errors': {
              'network': 'Access token expired or invalid, please log in again'
            }
          };
        }
      } else if (response.statusCode == 200) {
        // Request successful, return response body
        return jsonDecode(response.body);
      } else {
        // Other error, handle appropriately
        debugPrint('Request failed with status code: ${response.statusCode}');
        return {
          'errors': {
            'network': 'Something went wrong'
          }
        };
      }
    } on TimeoutException catch (_) {
      return {
        'errors': {
          'network': 'Request timed out, please try again'
        }
      };
    } on Error catch (_) {
      return {
        'errors': {
          'network': 'Something went wrong'
        }
      };
    } catch (_) {
      return {
        'errors': {
          'network': 'Something went wrong'
        }
      };
    }
  }

  Future<List<User>> getUser() async {
      var dialects = <User>[];
      try {
        var response = await http.get(
          Uri.parse(Api.getAllUsers),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        var body = json.decode(response.body);
        var success = body['status'];
        var data = body['data'];
        if (success == true) {

          var user = List.from(data).toList().map((e) => User.fromJson(e)).toList();

          return user;
        } else {
          return dialects;
        }
      } catch (e) {
        throw Exception(e);
      }
    }
  Future<List<UserInfo>> getUserInfo({
    String? date,
    String? firstCall,
  }) async {
    var dialects = <UserInfo>[];
    String call = firstCall ?? '';
    try {
      var response = await http.get(
        Uri.parse(date!=null ?Api.allInfo(date): call),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var data = body['data'];

      if (response.statusCode == 200) {
        var user = List.from(data)
            .map(
              (e) => UserInfo.fromJson(e),
        )
            .toList();

        return user;
      } else {
        return dialects;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<UserInfo> getUserInfoById(int? id) async {
    var dialects = UserInfo();
    try {
      var response = await http.get(
        Uri.parse(Api.getInfo(id.toString())),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);

      if (response.statusCode == 200) {
        var user = UserInfo.fromJson(body);

        return user;
      } else {
        return dialects;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
    Future<User> getUserById(String userId) async {
      var token = await sessionDataProvider.readsAccessToken();

      var users = User();
      var response = await http.get(
        Uri.parse(Api.getUser(userId)),
        headers: <String, String>{
          'Content-Type': 'application/json',
         HttpHeaders.authorizationHeader: "Bearer $token",


        },
      );

      try {
        var body = json.decode(response.body);
       var data = body['data'];
        var success = body['success'];
        if (success == true) {
          // print('succes');




          return  User.fromJson(data);

        }else if (isAccesTokenTimerActive || response.statusCode == 401) {
          bool isTrue = await refresh();

          if (isTrue) {
            return await getUserById(userId); // Call saveFavorite recursively after refreshing token
          } else {
            return users;
          }
        }  else {
          return users;
        }
      } catch (e) {
        debugPrint('$e');

      }
      return users;
    }
  Future<bool> deleteUser(int id) async {
    try {
      var response = await http.delete(
        Uri.parse(Api.deleteUser(id)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var success = body['status'];
      if (success == true) {
        return true;
      } else if (isAccesTokenTimerActive || response.statusCode == 401) {
        bool isTrue = await refresh();

        if (isTrue) {
          return await deleteUser(id); // Call saveFavorite recursively after refreshing token
        } else {
          return false;
        }
      }else {
        debugPrint('Delete $success');
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<InfoUser?> fetchInfoUser(http.Client client) async {
    final response =
    await client.get(Uri.https('165.227.204.177', '/api/info'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return InfoUser.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load InfoUser');
    }
  }
  }