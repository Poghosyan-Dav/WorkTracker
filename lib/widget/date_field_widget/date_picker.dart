import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerBottomSheetModal extends StatefulWidget {
  final dynamic answer;
  final Function? changeDateTime;
  final Function? clearDateTime;
  final CupertinoDatePickerMode mode;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const DatePickerBottomSheetModal({
    Key? key,
    required this.answer,
    required this.changeDateTime,
    required this.clearDateTime,
    this.mode = CupertinoDatePickerMode.dateAndTime,
    this.minimumDate,
    this.maximumDate,
  }) : super(key: key);

  @override
  DatePickerBottomSheetModalState createState() =>
      DatePickerBottomSheetModalState();
}

class DatePickerBottomSheetModalState
    extends State<DatePickerBottomSheetModal> {
  DateTime? _chosenDate;
  get _initialDate {
    return widget.answer ?? DateTime.now();
  }

  void handleDate(DateTime? date) {
    if (date != null) {
      _chosenDate = date;
    }
  }

  DateTime getInitialDate() {
    if (widget.maximumDate != null) {
      if (!DateTime.parse(_initialDate.toString()).isAtSameMomentAs(DateTime.parse('1990-01-01'))) {
        if (DateTime.parse(_initialDate.toString()).isBefore(widget.maximumDate!)) {
          return _initialDate;
        } else {
          return widget.maximumDate!;
        }
      } else {
        return DateTime.parse('1990-01-01');
      }
    }
    if (widget.minimumDate != null) {
      if (!DateTime.parse(_initialDate.toString()).isAtSameMomentAs(DateTime.parse('2050-12-31'))) {
        if (DateTime.parse(_initialDate.toString()).isAfter(widget.minimumDate!)) {
          return _initialDate;
        } else {
          return widget.minimumDate!;
        }
      } else {
        return DateTime.parse('2050-12-31');
      }
    }
    return _initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 56,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  widget.clearDateTime!();
                  //  widget.getBorderColor(null);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                      letterSpacing: 0.2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              Container(
                height: 36,
                width: 72,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2DB342),
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      if (_chosenDate != null) {
                        widget.changeDateTime!(_chosenDate);
                        Navigator.of(context).pop();
                      } else {
                        _chosenDate = getInitialDate();
                        // _chosenDate = widget.answer ??
                        //     DateTime.parse('${DateFormat('MMMM d, y').format(DateTime.now())} at ${DateFormat('HH:mm').format(DateTime.now())}');
                        widget.changeDateTime!(_chosenDate);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2DB342),
                          letterSpacing: 0.2,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 160,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: CupertinoDatePicker(
            initialDateTime: getInitialDate(),
            onDateTimeChanged: (DateTime newDate) {
              handleDate(newDate);
            },
            use24hFormat: true,
            maximumDate: widget.maximumDate,
            minimumYear: 1990,
            maximumYear: 2050,
            minimumDate: widget.minimumDate,
            minuteInterval: 1,
            mode: widget.mode,
          ),
        )
      ],
    );
  }
}