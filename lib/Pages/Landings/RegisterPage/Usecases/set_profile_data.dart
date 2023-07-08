import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Validators/commands.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

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
  StateSetProfileData createState() => StateSetProfileData();
}

class StateSetProfileData extends State<SetProfileData>
    with SingleTickerProviderStateMixin {
  AuthCommandsService apiService;
  var usernameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  AnimationController lottieController;

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(vsync: this);
    apiService = AuthCommandsService();
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;

    Widget getDataDetailForm(bool status) {
      if (status && !successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Username", darkColor, TextAlign.left),
            getInputWarning(widget.unameMsg),
            getInputTextRegis(30, "username", usernameCtrl, refresh,
                usernameAvaiabilityCheck, isCheckedRegister),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", emailCtrl, refresh,
                emailAvaiabilityCheck, isCheckedRegister),
            InkWell(
                onTap: () {
                  lottieController.reset();
                  usernameAvaiabilityCheck = "";
                  usernameCtrl.clear();
                  emailCtrl.clear();
                  widget.unameMsg = "";
                  widget.emailMsg = "";
                  emailAvaiabilityCheck = "";
                  checkAvaiabilityRegis = false;
                  refreshPage(refresh);
                  Get.snackbar("Success", "Username and Email is reset",
                      backgroundColor: whiteColor);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: spaceLG),
                  child: RichText(
                      text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.refresh,
                            size: iconMD + 2, color: warningBG),
                      ),
                      TextSpan(
                        style: TextStyle(
                            color: warningBG,
                            fontSize: textMD,
                            fontWeight: FontWeight.w500),
                        text: " Reset Username and Email".tr,
                      ),
                    ],
                  )),
                )),
            getSubTitleMedium("Password", darkColor, TextAlign.left),
            getInputWarning(widget.passMsg),
            getInputTextRegis(
                35, "pass", null, refresh, passRegisCtrl, isFillForm),
            getSubTitleMedium("First Name".tr, darkColor, TextAlign.left),
            getInputWarning(widget.fnameMsg),
            getInputTextRegis(
                35, "fname", null, refresh, fnameRegisCtrl, isFillForm),
            getSubTitleMedium("Last Name".tr, darkColor, TextAlign.left),
            getInputWarning(widget.lnameMsg),
            getInputTextRegis(
                35, "lname", null, refresh, lnameRegisCtrl, isFillForm),
            getSubTitleMedium("Valid Until".tr, darkColor, TextAlign.left),
            getDropDownMain(slctValidUntil, validUntil, (String newValue) {
              setState(() {
                slctValidUntil = newValue;
              });
            }, false, null),
            getInputWarning(widget.allMsg),
          ],
        );
      } else if (status && successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Username", darkColor, TextAlign.left),
            getInputWarning(widget.unameMsg),
            getInputTextRegis(30, "username", usernameCtrl, refresh,
                usernameAvaiabilityCheck, isFillForm),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", emailCtrl, refresh,
                emailAvaiabilityCheck, isFillForm),
            Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/json/success-popup.json',
                controller: lottieController,
                onLoaded: (composition) {
                  lottieController
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Username", darkColor, TextAlign.left),
            getInputWarning(widget.unameMsg),
            getInputTextRegis(30, "username", usernameCtrl, refresh,
                usernameAvaiabilityCheck, isFillForm),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", emailCtrl, refresh,
                emailAvaiabilityCheck, isFillForm),
            Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: Image.asset('assets/icon/check_user.png',
                      width: fullHeight * 0.25),
                )),
            const Text(
              "Before you can fill the other form. We must validate your username and email first",
              textAlign: TextAlign.center,
            ),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    RegisteredModel data = RegisteredModel(
                      username: usernameAvaiabilityCheck.trim(),
                      email: emailAvaiabilityCheck.trim(),
                    );

                    Map<String, dynamic> valid =
                        AuthValidator.validateAccount(data);
                    if (valid['status']) {
                      apiService.postCheckUser(data).then((response) {
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          successValidateAnimation = true;
                          checkAvaiabilityRegis = true;
                          isCheckedRegister = true;
                          widget.unameMsg = "";
                          widget.emailMsg = "";
                          refreshPage(refresh);

                          Future.delayed(const Duration(seconds: 2), () {
                            successValidateAnimation = false;
                            refreshPage(refresh);
                            Get.snackbar(
                                "Success", "Username and Email is available",
                                backgroundColor: whiteColor);
                          });
                        } else {
                          checkAvaiabilityRegis = false;
                          refreshPage(refresh);
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FailedDialog(text: body, type: "regis"));
                        }
                      });
                    } else {
                      if (valid['loc'] == "username") {
                        widget.unameMsg = valid['message'];
                      } else if (valid['loc'] == "email") {
                        widget.emailMsg = valid['message'];
                      }
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => FailedDialog(
                              text: valid['message'], type: "regis"));
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    size: iconLG - 2,
                    color: whiteColor,
                  ),
                  label:
                      Text("Validate", style: TextStyle(fontSize: textMD - 2)),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundedMD),
                    )),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(primaryColor),
                  ),
                ))
          ],
        );
      }
    }

    // Future<ProfileData> getToken() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   if (isFillForm) {
    //     final data = jsonDecode(prefs.getString('profile_data_key'));
    //     return ProfileData(
    //         username: data['username'],
    //         email: data['email'],
    //         pass: data['password'],
    //         image: data['image_url'],
    //         fname: data['first_name'],
    //         lname: data['last_name']);
    //   } else {
    //     return ProfileData(
    //         username: "", email: "", pass: "", image: "", fname: "", lname: "");
    //   }
    // }

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
      padding: EdgeInsets.all(spaceLG),
      margin: EdgeInsets.fromLTRB(spaceLG, spaceJumbo * 1.75, spaceLG, spaceLG),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.35),
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
        getDataDetailForm(checkAvaiabilityRegis),
      ]),
    );
    //   } else {
    //     return const SizedBox();
    //   }
    // });
  }
}
