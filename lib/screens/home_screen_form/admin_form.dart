import 'package:flutter/material.dart';

import '../registration/registration_form.dart';
import '../users/users.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: IconButton(onPressed: ()=>Navigator.of(context).pushAndRemoveUntil(

              MaterialPageRoute(
                  builder: (context) =>
                      const UsersScreen()),
                  (Route<dynamic> route) =>
              false), icon:const Icon(Icons.arrow_back_ios_new_outlined)),
          title:const Text('Admin'),
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body:const Padding(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: SignupForm(),
        ),
      ),
    );  }
}
