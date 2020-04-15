import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suraksha/values/gradients.dart';

class MyDatePicker extends StatefulWidget {
  DateTime dateTime;

  MyDatePicker({this.dateTime});

  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
//  DateTime current;
  DateTime selecteddate;

  @override
  void initState() {
//     current=widget.dateTime;
    selecteddate = DateTime.now();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime lastDay = Utils.lastDayOfMonth(widget.dateTime);
    int today = widget.dateTime.day;
    int last = lastDay.day;

    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: last - today + 1,
          itemBuilder: (context, index) {
            print("index: " + index.toString());
            print("curr obj: " + widget.dateTime.toString());
            DateTime _date = widget.dateTime.add(Duration(days: index));
            DateTime date = new DateTime(_date.year, _date.month, _date.day);
//            bool isSelected = compareDate(date, current);

            return GestureDetector(
              child: Container(
                width: 40,

                margin: EdgeInsets.only(right: 5),
//                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: (selecteddate.day == date.day &&
                            selecteddate.month == date.month &&
                            selecteddate.year == date.year)
                        ? Gradients.redGradient
                        : null),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      new DateFormat("E", "en_US").format(date), // WeekDay
                      style: TextStyle(
                        fontSize: 12,
                        color: (selecteddate.day == date.day &&
                            selecteddate.month == date.month &&
                            selecteddate.year == date.year)? Colors.white: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      date.day.toString(), // Date
                      style: TextStyle(
                        fontSize: 12,
                          color: (selecteddate.day == date.day &&
                              selecteddate.month == date.month &&
                              selecteddate.year == date.year)? Colors.white: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  selecteddate = date;
                });
              },
            );
          }),
    );
  }

  bool compareDate(DateTime date1, DateTime date2) {
    print("compare: date: " + date1.toString() + " curr: " + date2.toString());
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
