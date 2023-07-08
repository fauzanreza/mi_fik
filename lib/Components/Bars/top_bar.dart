import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getAppbar(String title, var action) {
  return AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: action),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, semidarkColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    title: Text(title, style: TextStyle(fontSize: textLG)),
  );
}
