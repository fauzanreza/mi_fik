import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getNoDataContainer(String title) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: roundedErrImage,
          child: Image.asset('assets/icon/sorry.png', width: 120),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: greybg, fontSize: textMD)))
      ]);
}
