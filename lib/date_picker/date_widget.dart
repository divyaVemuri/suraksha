/// ***
/// This class consists of the DateWidget that is used in the ListView.builder
///
/// Author: Vivek Kaushik <me@vivekkasuhik.com>
/// github: https://github.com/iamvivekkaushik/
/// ***

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suraksha/date_picker/gestures/tap.dart';
import 'package:suraksha/values/gradients.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;
  final TextStyle monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback onDateSelected;
  final String locale;

  DateWidget(
      {@required this.date,
      @required this.monthTextStyle,
      @required this.dayTextStyle,
      @required this.dateTextStyle,
      @required this.selectionColor,
      this.onDateSelected,
      this.locale,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Container(
            margin: EdgeInsets.all(3),
            padding: EdgeInsets.only(top: 12,bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: selectionColor,
//        gradient: Gradients.redGradient
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//              Text(new DateFormat("MMM", locale).format(date).toUpperCase(), // Month
//                  style: monthTextStyle),
                  Text(new DateFormat("E", locale).format(date), // WeekDay
                      style: dayTextStyle),
                  SizedBox(height: 3,),
                  Text(date.day.toString(), // Date
                      style: dateTextStyle),

                ],
              ),
            ),
          ),
          onTap: () {
            // Check if onDateSelected is not null
            if (onDateSelected != null) {
              // Call the onDateSelected Function
              onDateSelected(this.date);
            }
          },
        ),
      ],
    );
  }
}
