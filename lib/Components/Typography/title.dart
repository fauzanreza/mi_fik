import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getTitleLarge(String title, var color) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: spaceXXSM),
    child: Text(title,
        style: TextStyle(
            color: color, fontSize: textLG, fontWeight: FontWeight.bold)),
  );
}

Widget getTitleJumbo(String title, var color) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: spaceXXSM + 1),
    child: Text(title,
        style: TextStyle(
            color: color, fontSize: textLG, fontWeight: FontWeight.bold)),
  );
}

Widget getSubTitleMedium(String title, var color, TextAlign align) {
  return Text(title,
      textAlign: align,
      style: TextStyle(
          color: color, fontSize: textXMD, fontWeight: FontWeight.w500));
}
