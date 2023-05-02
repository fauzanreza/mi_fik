import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getGreeting(String hours, var clr) {
  var hour = int.parse(hours);
  var greet = "";
  if (hour >= 0 && hour <= 12) {
    greet = "Good Morning";
  } else if (hour > 12 && hour <= 17) {
    greet = "Good Evening";
  } else if (hour > 17 && hour <= 24) {
    greet = "Good Night";
  }
  return Text(greet,
      style:
          TextStyle(color: clr, fontWeight: FontWeight.w500, fontSize: textXL));
}
