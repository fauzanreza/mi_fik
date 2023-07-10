import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getInputText(int len, var ctrl, bool secure) {
  return Container(
    padding: EdgeInsets.only(top: spaceSM * 0.2),
    child: TextField(
      cursorColor: darkColor,
      maxLength: len,
      autofocus: false,
      controller: ctrl,
      obscureText: secure,
      style: TextStyle(fontSize: textXMD),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        fillColor: whiteColor,
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(color: greyColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
      ),
    ),
  );
}

Widget getInputTextRegis(
    int len, String type, var ctrl, var refresh, String hint, bool check) {
  bool getEnabledEditing(bool check) {
    if (check) {
      return false;
    } else {
      return true;
    }
  }

  bool getObscure(type) {
    if (type == "pass") {
      return true;
    } else {
      return false;
    }
  }

  return Container(
    padding: EdgeInsets.only(top: spaceSM * 0.2),
    child: TextField(
      cursorColor: darkColor,
      maxLength: len,
      autofocus: false,
      obscureText: getObscure(type),
      controller: ctrl,
      style: TextStyle(fontSize: textXMD),
      onChanged: (val) {
        if (type == "username") {
          usernameAvaiabilityCheck = val;
        } else if (type == "email") {
          emailAvaiabilityCheck = val;
        } else if (type == "pass") {
          passRegisCtrl = val;
        } else if (type == "lname") {
          lnameRegisCtrl = val;
        } else if (type == "fname") {
          fnameRegisCtrl = val;
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        fillColor:
            getEnabledEditing(check) ? whiteColor : greyColor.withOpacity(0.5),
        filled: true,
        enabled: getEnabledEditing(check),
        hintText: hint,
        border: OutlineInputBorder(borderSide: BorderSide(color: greyColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
      ),
    ),
  );
}

void refreshPage(Function refreshCallback) {
  refreshCallback();
}

Widget getInputTextAtt(int len, String id, String obj) {
  return Container(
    padding: EdgeInsets.only(top: spaceSM * 0.2),
    child: TextField(
      cursorColor: darkColor,
      maxLength: len,
      autofocus: false,
      style: TextStyle(fontSize: textXMD),
      onChanged: (value) {
        int idx = listAttachment.indexWhere((e) => e['id'] == id);
        listAttachment[idx][obj] = value.trim();
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        fillColor: whiteColor,
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(color: greyColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
      ),
    ),
  );
}

Widget getInputDesc(int len, int lines, var ctrl, bool secure) {
  return Container(
    padding: EdgeInsets.only(top: spaceSM * 0.2),
    child: TextField(
      cursorColor: darkColor,
      maxLength: len,
      autofocus: false,
      controller: ctrl,
      obscureText: secure,
      maxLines: lines,
      minLines: lines,
      style: TextStyle(fontSize: textXMD),
      decoration: InputDecoration(
        fillColor: whiteColor,
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(color: greyColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedSM),
          borderSide: BorderSide(color: greyColor),
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
        borderRadius: BorderRadius.circular(roundedSM),
      ),
      child: DropdownButton(
        value: slct,
        underline: Container(
          height: 1.0,
          decoration: const BoxDecoration(border: null),
        ),
        style: TextStyle(fontSize: textXMD, color: primaryColor),
        items: opt.map((String item) {
          if (separate) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(ucFirst(
                  getSeparatedAfter(divider, item).replaceAll('_', ' '))),
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
