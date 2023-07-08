import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    bool isLoading = false;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: spaceXMD),
      margin:
          EdgeInsets.symmetric(horizontal: 20, vertical: fullHeight * 0.075),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(roundedLG)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
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
            getInputText(passwordLength, passCtrl, true),
            getInputWarning(allMsg),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                padding: EdgeInsets.zero,
                width: fullWidth,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    String token = await FirebaseMessaging.instance.getToken();
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
                        setState(() => isLoading = false);
                        var status = response[0]['message'];
                        var body = response[0]['body'];
                        var acc = response[0]['access'];

                        if (status == "success") {
                          if (acc) {
                            Get.to(() => const BottomBar());
                            userService.putFirebase(token);
                          } else {
                            usernameAvaiabilityCheck = body['username'];
                            emailAvaiabilityCheck = body['email'];
                            passRegisCtrl = body['password'];
                            fnameRegisCtrl = body['first_name'];
                            lnameRegisCtrl = body['last_name'];
                            validRegisCtrl = int.parse(body['valid_until']);

                            Get.to(() => const RegisterPage(
                                  isLogged: true,
                                ));
                            userService.putFirebase(token);
                          }
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FailedDialog(text: body, type: "login"));

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
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => FailedDialog(
                              text: valid['message'], type: "login"));
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundedMD),
                    )),
                    backgroundColor: MaterialStatePropertyAll<Color>(successBG),
                  ),
                  child: Text('Sign In', style: TextStyle(fontSize: textMD)),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: spaceXMD * 2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: spaceMD),
                          child: Text("already have an account?",
                              style: TextStyle(fontSize: textMD))),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                        ),
                        onPressed: () {
                          Get.to(() => const RegisterPage(
                                isLogged: false,
                              ));
                        },
                        child: Text('Register now',
                            style: TextStyle(fontSize: textMD)),
                      ),
                    ]))
          ]),
    );
  }
}
