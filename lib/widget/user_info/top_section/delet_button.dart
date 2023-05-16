import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function()? onDelete;

  const DeleteButton({super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onDelete == null ? 0.5 : 1.0,
      child: SizedBox(
        width: 36,
        height: 36  ,
        child: Material(
        color:const Color(0xFFECECEC),
    borderRadius:const BorderRadius.all(Radius.circular(8.0)),
    child: InkWell(
                onTap: onDelete,
                child:const Icon(
                  Icons.delete_forever_outlined,
                  color: Color(0xFF212121),
                ),
              )


    )));
  }
}