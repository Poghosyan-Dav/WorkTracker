import 'package:flutter/material.dart';
import 'package:worktracker/screens/Login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      appBar: AppBar(
        title:const Text('Login'),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
      ),
      body:const LoginForm(),
    ));
  }
}
