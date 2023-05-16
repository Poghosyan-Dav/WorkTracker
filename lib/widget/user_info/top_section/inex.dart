import 'package:flutter/material.dart';
import 'package:worktracker/widget/user_info/top_section/personal_datas.dart';

import 'delet_button.dart';
import 'edit_button.dart';

// Widgets

class TopSection extends StatelessWidget {
  final String fullName;
  final String lasName;
  final String userName;
  final String role;
  final bool isLoading;
  final Function() onEdit;
  final Function()? onDelete;


  const TopSection({super.key,
    required this.fullName,
    required this.lasName,
    required this.userName,
    required this.role,
    required this.isLoading,
    required this.onEdit,
     this.onDelete,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.only(bottom: 16.0, top: 16.0, left: 16.0, right: 19.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          PersonalData(
              fullName: fullName,
              userName: userName,
              lastName: lasName,
              role: role,
              isLoading: isLoading,

          ),
          EditButton(
            onEdit: onEdit,
          ),
          const SizedBox(width: 10,),
          DeleteButton(onDelete:onDelete!,
          )
        ],
      ),
    );
  }
}