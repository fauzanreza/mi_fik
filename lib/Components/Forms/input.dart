import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getInputText(int len, var ctrl, bool secure) {
  return Container(
    padding: EdgeInsets.only(top: paddingXSM * 0.2),
    child: TextField(
      cursorColor: blackbg,
      maxLength: len,
      autofocus: false,
      controller: ctrl,
      obscureText: secure,
      decoration: InputDecoration(
        fillColor: mainbg,
        filled: true,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

Widget getInputDesc(int len, int lines, var ctrl, bool secure) {
  return Container(
    padding: EdgeInsets.only(top: paddingXSM * 0.2),
    child: TextField(
      cursorColor: blackbg,
      maxLength: len,
      autofocus: false,
      controller: ctrl,
      obscureText: secure,
      maxLines: lines,
      minLines: lines,
      decoration: InputDecoration(
        fillColor: mainbg,
        filled: true,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
