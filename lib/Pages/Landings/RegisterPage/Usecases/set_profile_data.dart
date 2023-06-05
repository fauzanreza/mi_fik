import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SetProfileData extends StatefulWidget {
  const SetProfileData({Key key}) : super(key: key);

  @override
  _SetProfileData createState() => _SetProfileData();
}

class _SetProfileData extends State<SetProfileData> {
  AuthCommandsService apiService;

  @override
  void initState() {
    super.initState();
    apiService = AuthCommandsService();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;

    Widget getDataDetailForm(bool status) {
      if (status) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Password", blackbg, TextAlign.left),
            getInputTextRegis(35, "pass", context, null, refresh),
            getSubTitleMedium("First Name", blackbg, TextAlign.left),
            getInputTextRegis(35, "fname", context, null, refresh),
            getSubTitleMedium("Last Name", blackbg, TextAlign.left),
            getInputTextRegis(35, "lname", context, null, refresh),
            getSubTitleMedium("Valid Until", blackbg, TextAlign.left),
            getDropDownMain(slctValidUntil, validUntil, (String newValue) {
              setState(() {
                slctValidUntil = newValue;
              });
            }, false, null),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset('assets/icon/check_user.png',
                  width: fullHeight * 0.25),
            ),
            const Text(
              "Before you can fill the other form. We must validate your username and email first",
              textAlign: TextAlign.center,
            )
          ],
        );
      }
    }

    return Container(
      height: fullHeight * 0.75,
      padding: EdgeInsets.all(paddingMD),
      margin: EdgeInsets.fromLTRB(paddingMD, paddingLg, paddingMD, paddingMD),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: whitebg),
      child: ListView(children: [
        getTitleLarge("Profile Data", primaryColor),
        getSubTitleMedium("Username", blackbg, TextAlign.left),
        getInputTextRegis(30, "username", context, apiService, refresh),
        getSubTitleMedium("Email", blackbg, TextAlign.left),
        getInputTextRegis(30, "email", context, apiService, refresh),
        getDataDetailForm(checkAvaiabilityRegis),
      ]),
    );
  }
}
