import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/services/blocs/user/user_bloc.dart';
import 'package:worktracker/services/blocs/user/user_state.dart';

import 'top_section/inex.dart';


class InfoSection extends StatelessWidget {
  // TopSection props
  final String fullName;
  final String lastName;
  final String userName;
  final String role;
  final bool isLoading;
  final Function() onEdit;
  final Function()? onDelete;

  const InfoSection({
    Key? key,
    this.onDelete,
    required this.fullName,
    required this.lastName,
    required this.userName,
    required this.role,
    required this.isLoading,
    required this.onEdit,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc,EditUserState>(

      builder: (context, state) {
        return Card(
          child: Column(
            children: <Widget>[
               TopSection(
                fullName: fullName,
                lasName: lastName,
                userName: userName,
                role: role,
                isLoading: isLoading,
                onEdit: onEdit,
                onDelete:onDelete,

              ),
            ],

          ),
        );
      }
    );
  }
}