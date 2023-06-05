import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Validators/commands.dart';
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

Widget getInputTextRegis(
    int len, String type, var ctx, AuthCommandsService api, var refresh) {
  void checkAccount() async {
    RegisteredModel data = RegisteredModel(
      username: usernameAvaiabilityCheck.trim(),
      email: emailAvaiabilityCheck.trim(),
    );

    Map<String, dynamic> valid = AuthValidator.validateAccount(data);
    if (valid['status']) {
      api.postCheckUser(data).then((response) {
        var status = response[0]['message'];
        var body = response[0]['body'];

        if (status == "success") {
          checkAvaiabilityRegis = true;
          refreshPage(refresh);
          Get.snackbar("Success", "Username and Email is available",
              backgroundColor: whitebg);
        } else {
          checkAvaiabilityRegis = false;
          refreshPage(refresh);
          showDialog<String>(
              context: ctx,
              builder: (BuildContext context) =>
                  FailedDialog(text: body, type: "login"));
        }
      });
    }
  }

  return Container(
    padding: EdgeInsets.only(top: paddingXSM * 0.2),
    child: TextField(
      cursorColor: blackbg,
      maxLength: len,
      autofocus: false,
      onSubmitted: (val) {
        if (type == "username") {
          usernameAvaiabilityCheck = val;
          checkAccount();
        } else if (type == "email") {
          emailAvaiabilityCheck = val;
          checkAccount();
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

void refreshPage(Function refreshCallback) {
  refreshCallback();
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
