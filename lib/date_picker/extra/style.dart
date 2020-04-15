import 'package:flutter/material.dart';
import 'package:suraksha/date_picker/extra/color.dart';
import 'package:suraksha/date_picker/extra/dimen.dart';

const TextStyle defaultMonthTextStyle = TextStyle(
  color: AppColors.defaultMonthColor,
  fontSize: Dimen.monthTextSize,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);

const TextStyle defaultDateTextStyle = TextStyle(
  color: AppColors.defaultDateColor,
  fontSize: Dimen.dateTextSize,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);

const TextStyle defaultDayTextStyle = TextStyle(
  color: AppColors.defaultDayColor,
  letterSpacing: 1,
  fontSize: Dimen.dayTextSize,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);
