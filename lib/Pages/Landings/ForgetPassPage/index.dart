import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Validators/commands.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/ForgetPassPage/Components/get_finish.dart';
import 'package:mi_fik/Pages/Landings/ForgetPassPage/Components/get_recovery.dart';
import 'package:mi_fik/Pages/Landings/ForgetPassPage/Components/get_validate.dart';
import 'package:onboarding/onboarding.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key key, this.isLogged}) : super(key: key);
  final bool isLogged;

  @override
  StateForgetPage createState() => StateForgetPage();
}

class StateForgetPage extends State<ForgetPage> {
  Widget materialButton;

  final passCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final tokenCtrl = TextEditingController();
  AuthCommandsService apiService;

  @override
  void initState() {
    super.initState();
    isWaitingLoad = true;
    apiService = AuthCommandsService();
    materialButton = _skipButton();
  }

  Timer timer;
  bool isOut = false;
  int remainingTimer = 0;
  Color timerColor = primaryColor;

  String passMsg = "";
  String tokenMsg = "";
  String unameMsg = "";
  String emailMsg = "";

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTimer > 180) {
          remainingTimer--;
        } else if (remainingTimer > 0) {
          timerColor = warningBG;
          remainingTimer--;
        } else {
          isOut = true;
        }
      });
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  Widget _skipButton({void Function(int) setIndex, double height}) {
    return InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (indexForget == 0) {
            if (checkAvaiabilityForget) {
              setState(() {
                if (isWaitingLoad) {
                  isWaitingLoad = false;
                  remainingTimer = 900;
                  startTimer();
                }

                setIndex(indexForget++);
              });
              setState(() {});
            } else {
              Get.dialog(FailedDialog(
                  text: "Please validate your account first".tr,
                  type: "forget"));
            }
          } else if (indexForget == 1) {
            EditPassModel data = EditPassModel(
              username: usernameCtrl.text.trim(),
              password: passCtrl.text.trim(),
              token: tokenCtrl.text.trim(),
            );

            Map<String, dynamic> valid = UserValidator.validateEditPass(data);
            if (valid['status']) {
              apiService.editPass(data).then((response) {
                var status = response[0]['message'];
                var body = response[0]['body'];

                if (status == "success") {
                  isFillForm = true;
                  setIndex(indexForget++);
                  setState(() {});
                  Get.snackbar("Success", body, backgroundColor: whiteColor);
                } else {
                  setState(() {
                    passMsg = body['password'];
                  });
                  Get.dialog(FailedDialog(text: body, type: "forget"));
                }
              });
              tokenCtrl.clear();
            } else {
              Get.dialog(FailedDialog(text: valid['message'], type: "forget"));
            }
          }
        },
        child: Container(
          padding: EdgeInsets.all(spaceXSM),
          decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: successBG, width: 2),
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
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            Icon(
              Icons.arrow_forward_rounded,
              size: iconLG,
              color: successBG,
            ),
            SizedBox(
              width: spaceXXSM,
            ),
            Text(
              'Next'.tr,
              style: TextStyle(
                  fontSize: textXMD,
                  color: successBG,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ));
  }

  Widget _backButton(
      {void Function(int) setIndex, bool isFirst, double width}) {
    Icon getIcon(check) {
      if (check) {
        return Icon(
          Icons.cancel,
          size: iconLG,
          color: warningBG,
        );
      } else {
        return Icon(
          Icons.arrow_back,
          size: iconLG,
          color: warningBG,
        );
      }
    }

    return InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (isFirst) {
            Get.dialog(AlertDialog(
              contentPadding: const EdgeInsets.all(10),
              title: Text('Warning'.tr, style: TextStyle(fontSize: textXMD)),
              content: SizedBox(
                width: width,
                height: 75,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: spaceSM),
                          child: Text(
                              "Are you sure want to close the password recovery?"
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: shadowColor, fontSize: textXMD)))
                    ]),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundedSM),
                    )),
                    backgroundColor: MaterialStatePropertyAll<Color>(warningBG),
                  ),
                  onPressed: () {
                    usernameCtrl.clear();
                    emailCtrl.clear();
                    tokenCtrl.clear();
                    passCtrl.clear();
                    if (timer != null && timer.isActive) {
                      timer.cancel();
                    }

                    checkAvaiabilityForget = false;
                    Get.offNamed(CollectionRoute.landing,
                        preventDuplicates: false);
                  },
                  child: Text("Yes".tr,
                      style: TextStyle(color: whiteColor, fontSize: textMD)),
                )
              ],
            ));
          } else {
            setState(() {
              setIndex(indexForget--);
            });
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: spaceLG, vertical: spaceXMD * 0.5),
            decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(color: warningBG, width: 2),
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
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: getIcon(isFirst)));
  }

  Widget finishBtn() {
    return InkWell(
        onTap: () async {
          usernameCtrl.clear();
          emailCtrl.clear();
          tokenCtrl.clear();
          passCtrl.clear();

          checkAvaiabilityForget = false;

          Get.offAllNamed(CollectionRoute.landing);
        },
        child: Container(
          padding: EdgeInsets.all(spaceXSM),
          decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: successBG, width: 2),
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
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: (Row(children: [
            Icon(
              Icons.check,
              size: iconLG,
              color: successBG,
            ),
            SizedBox(
              width: spaceXXSM,
            ),
            Text(
              'To login',
              style: TextStyle(
                  fontSize: textXMD,
                  color: successBG,
                  fontWeight: FontWeight.w500),
            ),
          ])),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    final onboardingPagesList = [
      PageModel(
          widget: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.0,
                  color: Colors.transparent,
                ),
              ),
              child: GetRecovery(
                emailMsg: emailMsg,
                unameMsg: unameMsg,
                emailCtrl: emailCtrl,
                usernameCtrl: usernameCtrl,
              ))),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.0,
                color: Colors.transparent,
              ),
            ),
            child: GetValidate(
              passMsg: passMsg,
              tokenMsg: tokenMsg,
              isOut: isOut,
              remainingTimer: remainingTimer,
              timerColor: timerColor,
              fun: () {
                isOut = false;
                timerColor = primaryColor;
                timer.cancel();
                remainingTimer = 900;
                startTimer();
              },
              passCtrl: passCtrl,
              emailCtrl: emailCtrl,
              usernameCtrl: usernameCtrl,
              tokenCtrl: tokenCtrl,
              timerCtrl: timer,
            )),
      ),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(width: 0.0, color: Colors.transparent),
            ),
            child: const GetFinish()),
      ),
    ];

    return WillPopScope(
        onWillPop: () async {
          // Do something LOL
          return false;
        },
        child: Scaffold(
            body: Onboarding(
          pages: onboardingPagesList,
          onPageChange: (int pageIndex) {
            setState(() {
              indexForget = pageIndex;
            });
          },
          startPageIndex: indexForget,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 0.0, color: Colors.transparent),
              ),
              child: ColoredBox(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(spaceLG),
                  child: Row(
                    children: [
                      indexForget == 0
                          ? _backButton(
                              setIndex: setIndex,
                              isFirst: true,
                              width: fullWidth)
                          : indexForget != 0 && indexForget != pagesLength - 1
                              ? _backButton(
                                  setIndex: setIndex,
                                  isFirst: false,
                                  width: fullWidth)
                              : const SizedBox(),
                      SizedBox(width: spaceLG + spaceMini),
                      CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          closedIndicator: ClosedIndicator(color: primaryColor),
                          activeIndicator: ActiveIndicator(
                              color: shadowColor.withOpacity(0.25)),
                          indicatorDesign: IndicatorDesign.polygon(
                            polygonDesign: PolygonDesign(
                              polygon: DesignType.polygon_circle,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      indexForget == pagesLength - 1
                          ? finishBtn()
                          : _skipButton(setIndex: setIndex, height: fullHeight)
                    ],
                  ),
                ),
              ),
            );
          },
        )));
  }
}
