import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getTitleLarge(String title, var color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text(title,
        style: TextStyle(
            color: color, fontSize: textLG, fontWeight: FontWeight.w500)),
  );
}

Widget getTitleJumbo(String title, var color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Text(title,
        style: TextStyle(
            color: color, fontSize: textLG, fontWeight: FontWeight.bold)),
  );
}

Widget getSubTitleMedium(String title, var color) {
  return Text(title,
      style: TextStyle(
          color: color, fontSize: textMD, fontWeight: FontWeight.w500));
}
