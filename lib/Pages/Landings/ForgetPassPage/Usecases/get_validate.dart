import 'dart:async';

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
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class GetValidate extends StatefulWidget {
  GetValidate(
      {Key key,
      this.passMsg,
      this.tokenMsg,
      this.isOut,
      this.remainingTimer,
      this.timerColor,
      this.fun,
      this.passCtrl,
      this.usernameCtrl,
      this.emailCtrl,
      this.tokenCtrl,
      this.timerCtrl})
      : super(key: key);
  String passMsg = "";
  String tokenMsg = "";
  bool isOut;
  int remainingTimer;
  Color timerColor;
  Function fun;
  TextEditingController passCtrl;
  TextEditingController usernameCtrl;
  TextEditingController emailCtrl;
  TextEditingController tokenCtrl;
  Timer timerCtrl;

  @override
  StateGetValidate createState() => StateGetValidate();
}

class StateGetValidate extends State<GetValidate>
    with SingleTickerProviderStateMixin {
  AnimationController lottieController;

  bool isRestart = false;
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

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // double fullHeight = MediaQuery.of(context).size.height;

    Widget getDataDetailForm(bool status) {
      if (status && !successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("New Password", darkColor, TextAlign.left),
            getInputWarning(widget.passMsg),
            getInputTextRegis(30, "pass", widget.passCtrl, refresh,
                widget.passMsg, isFillForm),
          ],
        );
      } else if (status && successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: getSubTitleMedium("Token", darkColor, TextAlign.center)),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: Pinput(
                  enabled: !widget.isOut && !tokenValidated,
                  length: 6,
                  controller: widget.tokenCtrl,
                  disabledPinTheme: PinTheme(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.5),
                          border: Border.all(color: darkColor, width: 1),
                          borderRadius: BorderRadius.all(
                              Radius.circular(roundedCircle)))),
                  keyboardType: TextInputType.text,
                  defaultPinTheme: PinTheme(
                    width: 40,
                    height: 40,
                    textStyle: TextStyle(
                        fontSize: textLG,
                        color: darkColor,
                        fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              isInvalidToken == false ? darkColor : warningBG),
                      borderRadius: BorderRadius.circular(roundedXLG),
                    ),
                  ),
                  onCompleted: (pin) {
                    RequestRecoverModel data = RequestRecoverModel(
                        username: widget.usernameCtrl.text.trim(),
                        email: widget.emailCtrl.text.trim(),
                        token: pin,
                        type: "first");

                    Map<String, dynamic> valid =
                        AuthValidator.validateAccount(data);
                    if (valid['status']) {
                      apiService.postValdRecover(data).then((response) {
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          widget.tokenCtrl.text = pin;
                          tokenValidated = true;
                          successValidateAnimation = true;
                          refreshPage(refresh);

                          Future.delayed(const Duration(seconds: 2), () {
                            successValidateAnimation = false;
                            refreshPage(refresh);
                            Get.snackbar("Success", body,
                                backgroundColor: whiteColor);
                          });
                          if (widget.timerCtrl != null &&
                              widget.timerCtrl.isActive) {
                            widget.timerCtrl.cancel();
                          }
                        } else {
                          widget.tokenCtrl.clear();
                          isInvalidToken = true;
                          refreshPage(refresh);
                          Get.dialog(FailedDialog(text: body, type: "forget"));
                        }
                      });
                    } else {
                      widget.tokenCtrl.clear();
                      Get.dialog(
                          FailedDialog(text: valid['message'], type: "forget"));
                    }
                  },
                )),
            getInputWarning(widget.tokenMsg),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: Text(
                  formatTime(widget.remainingTimer),
                  style: TextStyle(
                      fontSize: textXJumbo,
                      color: widget.timerColor,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: widget.isOut == false
                    ? Text(
                        "You have 15 minutes to validate the token",
                        style: TextStyle(fontSize: textMD),
                      )
                    : Text("Time's up, please try again",
                        style: TextStyle(fontSize: textMD, color: warningBG))),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: isRestart == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text("Dont receive any email?",
                                style: TextStyle(fontSize: textMD)),
                            SizedBox(width: spaceMD),
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  RequestRecoverModel data =
                                      RequestRecoverModel(
                                          username:
                                              widget.usernameCtrl.text.trim(),
                                          email: widget.emailCtrl.text.trim(),
                                          token: "AAA123",
                                          type: "try_again");

                                  Map<String, dynamic> valid =
                                      AuthValidator.validateAccount(data);
                                  if (valid['status']) {
                                    apiService
                                        .postValdRecover(data)
                                        .then((response) {
                                      var status = response[0]['message'];
                                      var body = response[0]['body'];

                                      if (status == "success") {
                                        if (widget.remainingTimer == 0) {
                                          isRestart = true;
                                          widget.fun();
                                          refreshPage(refresh);
                                        }

                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          isRestart = false;
                                          refreshPage(refresh);
                                          Get.snackbar("Success", body,
                                              backgroundColor: whiteColor);
                                        });
                                      } else {
                                        refreshPage(refresh);
                                        Get.dialog(FailedDialog(
                                            text: body, type: "forget"));
                                      }
                                    });
                                  } else {
                                    Get.dialog(FailedDialog(
                                        text: valid['message'],
                                        type: "forget"));
                                  }
                                  widget.tokenCtrl.clear();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(spaceXSM),
                                  decoration: BoxDecoration(
                                      color: successBG,
                                      border: Border.all(
                                          color: whiteColor, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(roundedLG))),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.mail,
                                            color: whiteColor, size: iconMD),
                                        SizedBox(width: spaceMD),
                                        Text("Resend Email".tr,
                                            style: TextStyle(
                                              fontSize: textMD,
                                              color: whiteColor,
                                            ))
                                      ]),
                                ),
                              ),
                            )
                          ])
                    : Text("Token has resend to your email",
                        style: TextStyle(fontSize: textLG, color: successBG)))
          ],
        );
      }
    }

    return ListView(
        padding: EdgeInsets.fromLTRB(
            spaceLG, spaceJumbo + spaceXMD, spaceLG, spaceLG),
        children: [
          getTitleLarge("Set your new password", primaryColor),
          getDataDetailForm(tokenValidated),
        ]);
  }
}
