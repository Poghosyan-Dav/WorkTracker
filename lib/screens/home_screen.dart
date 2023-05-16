// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/ui/with_foreground_task.dart';
// import 'package:worktracker/screens/Login/login_screen.dart';
// import 'package:worktracker/screens/home_screen_form/user_form.dart';
// import 'package:worktracker/screens/users/users.dart';
// import 'package:worktracker/services/data_provider/session_data_providers.dart';
//
//
// class HomeScreen extends StatefulWidget {
//
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
// final SessionDataProvider _sessionDataProvider = SessionDataProvider();
// //String? _token;
// String?  isAUser;
// String? isValid;
// bool? isUser = false;
//   @override
//   void initState() {
//     loginUser();
//     super.initState();
//   }
//
//
// Future<void> loginUser() async {
//   isValid = await _sessionDataProvider.readsAccessToken();
//   isAUser = await _sessionDataProvider.readRole();
//   if (isValid != null && isAUser == "true") {
//     setState(() {
//       isUser = true;
//     });
//   } else {
//     setState(() {
//       isUser = isUser;
//     });
//   }
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return  WithForegroundTask(child: Scaffold(body: isValid !=null  && !isUser!  ? const UsersScreen():isValid !=null  && isUser! ?const UserScreen() : const LoginScreen()));
//   }
// }
