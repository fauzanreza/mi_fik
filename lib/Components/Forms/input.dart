import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
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
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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

Widget getInputTextAtt(int len, String id, String obj) {
  return Container(
    padding: EdgeInsets.only(top: paddingXSM * 0.2),
    child: TextField(
      cursorColor: blackbg,
      maxLength: len,
      autofocus: false,
      onChanged: (value) {
        int idx = listAttachment.indexWhere((e) => e['id'] == id);
        listAttachment[idx][obj] = value.trim();
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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

Widget getDropDownMain(String slct, List<String> opt,
    Function(String) onChanged, bool separate, String divider) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton(
        value: slct,
        underline: Container(
          height: 1.0,
          decoration: const BoxDecoration(border: null),
        ),
        style: TextStyle(fontSize: textMD, color: primaryColor),
        items: opt.map((String item) {
          if (separate) {
            return DropdownMenuItem<String>(
              value: item,
              child:
                  Text(getSeparatedAfter(divider, item).replaceAll('_', ' ')),
            );
          } else {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }
        }).toList(),
        onChanged: onChanged,
      ));
}
