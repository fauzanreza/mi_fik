import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SetProfileData extends StatefulWidget {
  SetProfileData(
      {Key key,
      this.usernameCtrl,
      this.emailCtrl,
      this.passCtrl,
      this.validCtrl,
      this.fnameCtrl,
      this.lnameCtrl})
      : super(key: key);
  TextEditingController usernameCtrl;
  TextEditingController emailCtrl;
  TextEditingController passCtrl;
  int validCtrl;
  TextEditingController fnameCtrl;
  TextEditingController lnameCtrl;

  @override
  _SetProfileData createState() => _SetProfileData();
}

class _SetProfileData extends State<SetProfileData> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(paddingMD),
          margin:
              EdgeInsets.fromLTRB(paddingMD, paddingLg, paddingMD, paddingMD),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: whitebg),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            getTitleLarge("Profile Data", primaryColor),
            getSubTitleMedium("Username", primaryColor, TextAlign.left),
            getInputText(75, widget.usernameCtrl, false),
            getSubTitleMedium("Email", primaryColor, TextAlign.left),
            getInputText(75, widget.emailCtrl, false),
            getSubTitleMedium("Password", primaryColor, TextAlign.left),
            getInputText(75, widget.passCtrl, false),
            getSubTitleMedium("First Name", primaryColor, TextAlign.left),
            getInputText(75, widget.fnameCtrl, false),
            getSubTitleMedium("Last Name", primaryColor, TextAlign.left),
            getInputText(75, widget.lnameCtrl, false)
          ]),
        )
      ],
    );
  }
}
