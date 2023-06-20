import 'package:flutter/material.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';

class DeleteUserDialog extends StatelessWidget {
  final bool isFromUserCardForm;
  const DeleteUserDialog({super.key,required this.onDeleted,required this.isFromUserCardForm});

  final Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: isFromUserCardForm ? const Text('Are you sure you want to delete this User?'): const Text('Are you sure you want to delete?'),
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


