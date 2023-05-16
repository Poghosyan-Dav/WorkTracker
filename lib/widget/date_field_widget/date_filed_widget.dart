import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worktracker/widget/date_field_widget/date_picker.dart';

class DateFieldWidget extends StatefulWidget {
  final String? name;
  final String? subName;
  final Function? onChange;
  final bool? hasIcon;
  final String? prefixText;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const DateFieldWidget({
    Key? key,
    required this.name,
    this.subName,
    this.hasIcon=false,
    required this.onChange,
    this.minimumDate,
    this.maximumDate,
    this.prefixText
  }) : super(key: key);

  @override
  DateFieldWidgetState createState() => DateFieldWidgetState();
}

class DateFieldWidgetState extends State<DateFieldWidget> {
  DateTime? dateValue;

  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showModalBottomSheet(
                      isDismissible: true,
                      barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
                      elevation: 3,
                      useRootNavigator: true,
                      context: context,
                      builder: (newContext) => DatePickerBottomSheetModal(
                        answer: DateTime.parse(DateFormat('yyyy-MM-dd 00:00').format(DateTime.now())),
                        changeDateTime: (date) {
                          String newDate = getDateToUTC(date.toString());
                          widget.onChange!(newDate);
                          setState(() { dateValue = date; });
                        },
                        clearDateTime: () {
                          widget.onChange!(null);
                       //   setState(() { dateValue  });
                        },
                        maximumDate: widget.maximumDate,
                        minimumDate: widget.minimumDate,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                          height: 56,
                          padding:  const EdgeInsets.only(top: 8) ,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color:const Color(0xFFCFD8DC),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0)
                              ),
                              color: Colors.white
                          ),
                          child: TextFormField(
                            controller: TextEditingController()..text = dateValue != null ?  ( DateFormat.yMMMd().format(dateValue!)):'',
                            onChanged: (val){
                              widget.onChange!(dateValue != null ? getDateToUTC(dateValue.toString()) : null);
                            },
                            onSaved: (val){
                              widget.onChange!(dateValue != null ? getDateToUTC(dateValue.toString()) : null);
                            },
                            enabled: false,
                            style: const TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 16
                            ),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 14, bottom: 10.0, top: 0, right: 32.0),
                                labelText:  dateValue!=null? '' : widget.name,
                                labelStyle: const TextStyle(
                                    color:  Color(0xFF6A6A6A)
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.none
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.none
                                  ),
                                )
                            ),
                          )
                      ),
                      Positioned(
                        right: 8.0,
                        top: 16.0,
                        child: SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: Icon(
                              !widget.hasIcon!? Icons.arrow_drop_down: Icons.calendar_month,
                              color: const Color(0xFF212121)
                          ),
                        ),
                      ),
                      !widget.hasIcon!? const SizedBox() :  Positioned.fill(
                          top: 7,
                          left: 15,
                          child: Text("${widget.subName}"))
                    ],
                  ),
                ),
                // (snapshot.hasError && snapshot.error != '' && snapshot.error != null) ? Container(
                //   margin: EdgeInsets.only(top: 4.0, bottom: 12.0),
                //   child: Text(
                //     "${snapshot.error}",
                //     style: TextStyle(
                //         fontFamily: 'Roboto',
                //         fontSize: 12,
                //         letterSpacing: 0.048,
                //         color: Color(0xFFFF0000)
                //     ),
                //   ),
                // ) : Container(
                //   margin: EdgeInsets.only(bottom: 20.0),
                // ),
              ]

    );
  }
  String getDateToUTC(String date) {
    String timeZoneOffset = getTimeZoneOffset(DateTime.now().timeZoneOffset);
    return DateFormat().addPattern("yyyy-MM-dd'T'HH:mm:ss.S'$timeZoneOffset'").format(DateTime.parse(date));
  }
  String getTimeZoneOffset(Duration timeZoneOffset) {
    String dateName = '';
    String minutes = '';

    if (timeZoneOffset.inMinutes.abs() % 60 < 10) {
      minutes = '0${timeZoneOffset.inMinutes.abs() % 60}';
    } else {
      minutes = '${timeZoneOffset.inMinutes.abs() % 60}';
    }

    if (timeZoneOffset.inHours < 0) {
      dateName = '-';
    } else {
      dateName = '+';
    }

    if (timeZoneOffset.inHours < 10 && timeZoneOffset.inHours > -10) {
      dateName += '0${timeZoneOffset.inHours.abs()}:$minutes';
    } else {
      dateName += '${timeZoneOffset.inHours.abs()}:$minutes';
    }

    return dateName;
  }
}