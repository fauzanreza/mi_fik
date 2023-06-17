import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetProfileData extends StatefulWidget {
  SetProfileData(
      {Key key,
      this.fnameMsg,
      this.lnameMsg,
      this.passMsg,
      this.allMsg,
      this.unameMsg,
      this.emailMsg})
      : super(key: key);
  String fnameMsg = "";
  String lnameMsg = "";
  String unameMsg = "";
  String allMsg = "";
  String passMsg = "";
  String emailMsg = "";

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
            getInputWarning(widget.passMsg),
            getInputTextRegis(
                35, "pass", context, null, refresh, passRegisCtrl, isFillForm),
            getSubTitleMedium("First Name", blackbg, TextAlign.left),
            getInputWarning(widget.fnameMsg),
            getInputTextRegis(35, "fname", context, null, refresh,
                fnameRegisCtrl, isFillForm),
            getSubTitleMedium("Last Name", blackbg, TextAlign.left),
            getInputWarning(widget.lnameMsg),
            getInputTextRegis(35, "lname", context, null, refresh,
                lnameRegisCtrl, isFillForm),
            getSubTitleMedium("Valid Until", blackbg, TextAlign.left),
            getDropDownMain(slctValidUntil, validUntil, (String newValue) {
              setState(() {
                slctValidUntil = newValue;
              });
            }, false, null),
            getInputWarning(widget.allMsg),
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

    Future<ProfileData> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      if (isFillForm) {
        final data = jsonDecode(prefs.getString('profile_data_key'));
        return ProfileData(
            username: data['username'],
            email: data['email'],
            pass: data['password'],
            image: data['image_url'],
            fname: data['first_name'],
            lname: data['last_name']);
      } else {
        return ProfileData(
            username: "", email: "", pass: "", image: "", fname: "", lname: "");
      }
    }

    //return
    // FutureBuilder<ProfileData>(
    //     future: getToken(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         if (isFillForm) {
    //           usernameAvaiabilityCheck = snapshot.data.username;
    //         } else {}

    return Container(
      height: fullHeight * 0.75,
      padding: EdgeInsets.all(paddingMD),
      margin: EdgeInsets.fromLTRB(
          paddingMD, paddingLg * 1.75, paddingMD, paddingMD),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: whitebg,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: const Offset(
              5.0,
              5.0,
            ),
          )
        ],
      ),
      child: ListView(children: [
        getTitleLarge("Profile Data", primaryColor),
        getSubTitleMedium("Username", blackbg, TextAlign.left),
        getInputWarning(widget.unameMsg),
        getInputTextRegis(30, "username", context, apiService, refresh,
            usernameAvaiabilityCheck, isFillForm),
        getSubTitleMedium("Email", blackbg, TextAlign.left),
        getInputWarning(widget.emailMsg),
        getInputTextRegis(30, "email", context, apiService, refresh,
            emailAvaiabilityCheck, isFillForm),
        getDataDetailForm(checkAvaiabilityRegis),
      ]),
    );
    //   } else {
    //     return const SizedBox();
    //   }
    // });
  }
}
