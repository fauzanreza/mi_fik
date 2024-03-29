import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getNoDataContainer(String title, double size) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(roundedJumbo + roundedJumbo),
          child: Image.asset('assets/icon/sorry.png', width: size),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: spaceSM),
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: shadowColor, fontSize: textXMD)))
      ]);
}
