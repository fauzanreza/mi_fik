import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Validators/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/ForgetPassPage/index.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/index.dart';

class PostLogin extends StatefulWidget {
  const PostLogin({Key key}) : super(key: key);

  @override
  StatePostLogin createState() => StatePostLogin();
}

class StatePostLogin extends State<PostLogin> {
  var usernameCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  AuthCommandsService apiService;
  UserCommandsService userService;
  String usernameMsg = "";
  String passMsg = "";
  String allMsg = "";
  bool isHide = true;
  bool isLoadLogin = false;

  @override
  void dispose() {
    usernameCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = AuthCommandsService();
    userService = UserCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: spaceJumbo - spaceMini, horizontal: spaceXMD),
      margin: EdgeInsets.symmetric(
          horizontal: spaceLG, vertical: fullHeight * 0.075),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(roundedLG)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: spaceLG),
              alignment: Alignment.center,
              child: ClipRRect(
                child: Image.asset('assets/icon/mifik_logo.png', width: 300),
              ),
            ),
            Text("Username",
                style: TextStyle(color: darkColor, fontSize: textXMD)),
            getInputWarning(usernameMsg),
            getInputText(lnameLength, usernameCtrl, false),
            Text("Password",
                style: TextStyle(color: darkColor, fontSize: textXMD)),
            getInputWarning(passMsg),
            Stack(
              children: [
                getInputText(passwordLength, passCtrl, isHide),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    iconSize: iconMD,
                    icon: FaIcon(
                        isHide == false
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        color: darkColor),
                    onPressed: () {
                      setState(() {
                        if (isHide) {
                          isHide = false;
                        } else {
                          isHide = true;
                        }
                      });
                    },
                  ),
                )
              ],
            ),
            getInputWarning(allMsg),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 0),
                foregroundColor: darkColor,
              ),
              onPressed: () {
                indexForget = 0;
                Get.to(() => const ForgetPage(
                      isLogged: false,
                    ));
              },
              child: Text('Forget Password'.tr,
                  style: TextStyle(fontSize: textMD)),
            ),
            Container(
                margin: EdgeInsets.only(top: spaceSM),
                padding: isLoadLogin == false
                    ? EdgeInsets.zero
                    : EdgeInsets.all(spaceMini),
                width: fullWidth,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isLoadLogin == false) {
                      setState(() {
                        isLoadLogin = true;
                      });
                      String token =
                          await FirebaseMessaging.instance.getToken();
                      usernameMsg = "";
                      passMsg = "";
                      allMsg = "";

                      LoginModel data = LoginModel(
                        username: usernameCtrl.text.trim(),
                        password: passCtrl.text.trim(),
                      );

                      Map<String, dynamic> valid =
                          AuthValidator.validateLogin(data);
                      if (valid['status']) {
                        apiService.postLogin(data, false).then((response) {
                          setState(() => {});
                          var status = response[0]['message'];
                          var body = response[0]['body'];
                          var acc = response[0]['access'];

                          if (status == "success") {
                            usernameKey = data.username;
                            if (acc) {
                              setState(() {
                                isLoadLogin = false;
                                isShownLostSessPop = false;
                              });
                              Get.to(() => const BottomBar());
                              userService.putFirebase(token);
                            } else {
                              usernameAvaiabilityCheck = body['username'];
                              emailAvaiabilityCheck = body['email'];
                              passRegisCtrl = body['password'];
                              fnameRegisCtrl = body['first_name'];
                              lnameRegisCtrl = body['last_name'];
                              validRegisCtrl = int.parse(body['batch_year']);

                              Get.to(() => const RegisterPage(
                                    isLogged: true,
                                  ));
                              userService.putFirebase(token);
                            }
                          } else {
                            Get.dialog(FailedDialog(text: body, type: "login"));

                            if (body is! String) {
                              if (body['username'] != null) {
                                usernameMsg = body['username'][0];

                                if (body['username'].length > 1) {
                                  for (String e in body['username']) {
                                    usernameMsg += e;
                                  }
                                }
                              }

                              if (body['password'] != null) {
                                passMsg = body['password'][0];

                                if (body['password'].length > 1) {
                                  for (String e in body['password']) {
                                    passMsg += e;
                                  }
                                }
                              }
                            } else {
                              allMsg = body;
                            }
                          }
                        });
                      } else {
                        Get.dialog(FailedDialog(
                            text: valid['message'], type: "login"));
                      }
                      setState(() {
                        isLoadLogin = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundedMD),
                    )),
                    backgroundColor: MaterialStatePropertyAll<Color>(successBG),
                  ),
                  child: isLoadLogin == false
                      ? Text('Sign In'.tr, style: TextStyle(fontSize: textMD))
                      : Center(
                          child: CircularProgressIndicator(color: whiteColor)),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: spaceXMD),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: spaceSM),
                          child: Text("don't have an account?".tr,
                              style: TextStyle(fontSize: textMD))),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                        ),
                        onPressed: () {
                          indexRegis = 0;
                          Get.to(() => const RegisterPage(
                                isLogged: false,
                              ));
                        },
                        child: Text('Register now'.tr,
                            style: TextStyle(fontSize: textMD)),
                      ),
                    ]))
          ]),
    );
  }
}
