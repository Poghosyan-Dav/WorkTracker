import 'package:flutter/material.dart';

class PersonalData extends StatelessWidget {
  final String fullName;
  final String lastName;
  final String userName;
  final bool isLoading;
  final String role;

  const PersonalData({super.key,
    required this.fullName,
    required this.lastName,
    required this.role,
    required this.userName,
    required this.isLoading,

  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 2.0, right: 8.0),
            child: Text(!fullName.toString().contains('null')? "First Name - $fullName":'',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: Color(0xFF212121),
              ),
            ),
          ),
       const SizedBox(height: 5),
        Text(
              !lastName.toString().contains("null")?"Last Name - $lastName":'Last Name',
              style:const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
                letterSpacing: 0.014,
              ),
            ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(top: 7.0),
            child:Text(
             !userName.toString().contains('null')? "User Name - $userName":'',
              style:const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.0,
                letterSpacing: 0.035,
                color: Color(0xFF6A6A6A),
              ),
            ),
          ),
            const  SizedBox(height: 5),
          Text(
            !role.toString().contains('null')? "role - $role":'',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14.0,
              letterSpacing: 0.035,
              color: Color(0xFF6A6A6A),
            ),
          ),
        ],
      ),
    );
  }
}