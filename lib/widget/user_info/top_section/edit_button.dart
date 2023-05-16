import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final Function()? onEdit;

  const EditButton({super.key,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onEdit == null ? 0.5 : 1.0,
      child:SizedBox(
          width: 36,
          height: 36  ,
          child: Material(
              color: const Color(0xFFECECEC),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                onTap: onEdit,
                child: const Icon(

                  Icons.edit,
                  color: Color(0xFF212121),

                ),
              )
          )

      ),
    );
  }
}