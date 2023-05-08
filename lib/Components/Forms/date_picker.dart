import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getDatePicker(
    DateTime ds, Function() actionPressed, String type, String view) {
  return TextButton.icon(
    style: TextButton.styleFrom(
      textStyle: const TextStyle(fontSize: 16),
      foregroundColor: blackbg,
    ),
    onPressed: actionPressed,
    icon: const Icon(
      Icons.calendar_month,
      size: 24.0,
    ),
    label: Text(getDateText(ds, type, view)),
  );
}
