library date_picker_timeline;


import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:suraksha/date_picker/date_widget.dart';
import 'package:suraksha/date_picker/extra/color.dart';
import 'package:suraksha/date_picker/extra/style.dart';
import 'package:suraksha/date_picker/gestures/tap.dart';

class DatePickerTimeline extends StatefulWidget {
  double width;
  double height;
  DateTime dateTime;

  TextStyle monthTextStyle, dayTextStyle, dateTextStyle;
  Color selectionColor;
  DateTime currentDate;
  DateChangeListener onDateChange;
  int daysCount;
  String locale;

  // Creates the DatePickerTimeline Widget
  DatePickerTimeline(
    this.currentDate,
      this.dateTime,
      {
    Key key,
    this.width,
    this.height = 80,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.daysCount = 50000,
    this.onDateChange,
    this.locale = "en_US",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DatePickerState();
}

class _DatePickerState extends State<DatePickerTimeline> {


  DateTime start;
  @override void initState() {
    super.initState();
    initializeDateFormatting(widget.locale, null);
  }

  @override
  Widget build(BuildContext context)  {

    start=widget.currentDate;

    final DateTime lastDay = Utils.lastDayOfMonth(start);
    int today=start.day;
    int last=lastDay.day;

    return Container(
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        itemCount: last-today+1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // Return the Date Widget
//          DateTime _date = DateTime.now().add(Duration(days: index));
//          DateTime date = new DateTime(_date.year, _date.month, _date.day);

          DateTime _date = start.add(Duration(days: index));
          DateTime date = new DateTime(_date.year, _date.month, _date.day);
          bool isSelected = compareDate(date, widget.currentDate);

          return DateWidget(
            date: date,
            monthTextStyle: widget.monthTextStyle,
            dateTextStyle: widget.dateTextStyle,
            dayTextStyle: widget.dayTextStyle,
            locale: widget.locale,
            selectionColor:
            isSelected ? widget.selectionColor : Colors.transparent,
            onDateSelected: (selectedDate) {
              // A date is selected
              if (widget.onDateChange != null) {
                widget.onDateChange(selectedDate);
              }
              setState(() {
                widget.currentDate = selectedDate;
              });
            },
          );
        },
      ),
    );
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
