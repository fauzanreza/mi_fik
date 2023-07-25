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

// ignore: must_be_immutable
class GetRecovery extends StatefulWidget {
  GetRecovery(
      {Key key,
      this.unameMsg,
      this.emailMsg,
      this.usernameCtrl,
      this.emailCtrl})
      : super(key: key);
  String unameMsg = "";
  String emailMsg = "";
  TextEditingController usernameCtrl;
  TextEditingController emailCtrl;

  @override
  StateGetRecovery createState() => StateGetRecovery();
}

class StateGetRecovery extends State<GetRecovery>
    with SingleTickerProviderStateMixin {
  AnimationController lottieController;
  AuthCommandsService apiService;

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
            getInputTextRegis(30, "username", widget.usernameCtrl, refresh,
                widget.unameMsg, checkAvaiabilityForget),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", widget.emailCtrl, refresh,
                widget.emailMsg, checkAvaiabilityForget),
            Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: Image.asset('assets/icon/send_email.png',
                      width: fullHeight * 0.25),
                )),
            Text(
              "We've send you password recovery token to your email. Please check it and move to next step",
              style: TextStyle(fontSize: textMD),
              textAlign: TextAlign.center,
            ),
          ],
        );
      } else if (status && successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Username", darkColor, TextAlign.left),
            getInputWarning(widget.unameMsg),
            getInputTextRegis(30, "username", widget.usernameCtrl, refresh,
                widget.unameMsg, isFillForm),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", widget.emailCtrl, refresh,
                widget.emailMsg, isFillForm),
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
            getInputTextRegis(30, "username", widget.usernameCtrl, refresh,
                widget.unameMsg, isFillForm),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(75, "email", widget.emailCtrl, refresh,
                widget.emailMsg, isFillForm),
            Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: Image.asset('assets/icon/check_user.png',
                      width: fullHeight * 0.25),
                )),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Please tell us your email and username",
                  style: TextStyle(fontSize: textMD),
                )),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    RegisteredModel data = RegisteredModel(
                      username: widget.usernameCtrl.text.trim(),
                      email: widget.emailCtrl.text.trim(),
                    );

                    Map<String, dynamic> valid =
                        AuthValidator.validateAccount(data);
                    if (valid['status']) {
                      apiService.postReqRecover(data).then((response) {
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          successValidateAnimation = true;
                          checkAvaiabilityForget = true;
                          widget.unameMsg = "";
                          widget.emailMsg = "";
                          refreshPage(refresh);

                          Future.delayed(const Duration(seconds: 2), () {
                            successValidateAnimation = false;
                            refreshPage(refresh);
                            Get.snackbar("Success", body,
                                backgroundColor: whiteColor);
                          });
                        } else {
                          checkAvaiabilityForget = false;
                          refreshPage(refresh);
                          Get.dialog(FailedDialog(text: body, type: "regis"));
                        }
                      });
                    } else {
                      if (valid['loc'] == "username") {
                        widget.unameMsg = valid['message'];
                      } else if (valid['loc'] == "email") {
                        widget.emailMsg = valid['message'];
                      }
                      Get.dialog(
                          FailedDialog(text: valid['message'], type: "regis"));
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    size: iconLG - 2,
                    color: whiteColor,
                  ),
                  label:
                      Text("Validate", style: TextStyle(fontSize: textXMD - 2)),
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

    return ListView(
        padding: EdgeInsets.fromLTRB(
            spaceLG, spaceJumbo + spaceXMD, spaceLG, spaceLG),
        children: [
          getTitleLarge("Validate your account", primaryColor),
          getDataDetailForm(checkAvaiabilityForget),
        ]);
  }
}
