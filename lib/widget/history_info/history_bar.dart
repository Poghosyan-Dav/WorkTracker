import 'package:flutter/material.dart';

class HistoryInfoAppBar extends StatelessWidget {

  const HistoryInfoAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 56.0,
            height: 56.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap:  () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                } ,
                borderRadius: const BorderRadius.all(Radius.circular(28.0)),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF212121),
                  size: 24.0,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Text( 'Hisorty',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                letterSpacing: 0.03,
                color: Color(0xFF212121),
              ),
            ),
          ),

        ],
      ),
    );
  }
}