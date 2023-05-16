import 'package:flutter/material.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';

class DeleteUserDialog extends StatelessWidget {

   DeleteUserDialog({super.key, required this.userId,required this.onDeleted});

  final int userId;
  final Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this User?'),
      actions: [
        TextButton(
          onPressed:onDeleted,
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}


