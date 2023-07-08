import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/nodata_dialog.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Validators/commands.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_terms.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_waiting.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_welcoming.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_profile_data.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_profile_image.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_role.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/post_selected_role.dart';
import 'package:onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key, this.isLogged}) : super(key: key);
  final bool isLogged;

  @override
  StateRegisterPage createState() => StateRegisterPage();
}

class StateRegisterPage extends State<RegisterPage> {
  Widget materialButton;

  UserCommandsService apiService;
  UserQueriesService apiQuery;

  AuthCommandsService authService;

  String checkMsg = "";
  String passMsg = "";
  String fnameMsg = "";
  String lnameMsg = "";
  String unameMsg = "";
  String emailMsg = "";
  String allMsg = "";

  @override
  void initState() {
    super.initState();
    fillValidUntil();
    apiService = UserCommandsService();
    apiQuery = UserQueriesService();

    authService = AuthCommandsService();
    materialButton = _skipButton();
  }

  fillValidUntil() {
    DateTime now = DateTime.now();
    var yearColl = [];
    for (int i = 1; i <= 5; i++) {
      yearColl.add(now.year + i);
      yearColl.add(now.year - i);
    }
    yearColl.add(2023);
    yearColl.sort();
    validUntil = yearColl.map((e) => e.toString()).toList();
  }

  Widget _skipButton({void Function(int) setIndex, double height}) {
    return InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () async {
          if (selectedRole.isEmpty && !isChooseRole && indexRegis == 4) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    NoDataDialog(text: "You haven't selected any tag yet".tr));
          } else if (selectedRole.isNotEmpty &&
              !isChooseRole &&
              indexRegis == 4) {
            showModalBottomSheet<void>(
              context: context,
              isDismissible: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(roundedLG),
                      topRight: Radius.circular(roundedLG))),
              barrierColor: primaryColor.withOpacity(0.5),
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                    height: height * 0.4,
                    padding: MediaQuery.of(context).viewInsets,
                    child: const PostSelectedRole(back: null, isLogged: false));
              },
            );
          } else if (selectedRole.isEmpty && !isFillForm && indexRegis == 2) {
            if (usernameAvaiabilityCheck.trim() != "" &&
                emailAvaiabilityCheck.trim() != "" &&
                passRegisCtrl.trim() != "" &&
                fnameRegisCtrl.trim() != "") {
              RegisterModel regisData = RegisterModel(
                  username: usernameAvaiabilityCheck.trim(),
                  email: emailAvaiabilityCheck.trim(),
                  password: passRegisCtrl.trim(),
                  firstName: fnameRegisCtrl.trim(),
                  lastName: lnameRegisCtrl.trim(),
                  validUntil: int.parse(slctValidUntil));

              Map<String, dynamic> valid =
                  UserValidator.validateRegis(regisData);

              if (valid['status']) {
                apiService.postUser(regisData).then((response) {
                  var status = response[0]['message'];
                  var body = response[0]['body'];

                  if (status == "success") {
                    LoginModel loginData = LoginModel(
                        username: usernameAvaiabilityCheck.trim(),
                        password: passRegisCtrl.trim());
                    authService.postLogin(loginData, true).then((value) {
                      // setIndex(indexRegis++);
                      setState(() {
                        fnameMsg = "";
                        lnameMsg = "";
                        passMsg = "";
                        allMsg = "";
                        isFillForm = true;
                      });

                      Get.snackbar("Success", "Account has been registered",
                          backgroundColor: whiteColor);
                    });
                  } else {
                    setState(() {
                      isFillForm = false;
                      if (body is! String) {
                        if (body['first_name'] != null) {
                          fnameMsg = body['first_name'][0];

                          if (body['first_name'].length > 1) {
                            for (String e in body['first_name']) {
                              fnameMsg += e;
                            }
                          }
                        }

                        if (body['last_name'] != null) {
                          fnameMsg = body['last_name'][0];

                          if (body['last_name'].length > 1) {
                            for (String e in body['last_name']) {
                              lnameMsg += e;
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
                    });

                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            FailedDialog(text: body, type: "register"));
                  }
                });
              } else {
                if (valid['loc'] == "username") {
                  unameMsg = valid['message'];
                } else if (valid['loc'] == "first_name") {
                  fnameMsg = valid['message'];
                } else if (valid['loc'] == "password") {
                  passMsg = valid['message'];
                }
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        FailedDialog(text: valid['message'], type: "regis"));
              }
            } else {
              if (checkAvaiabilityRegis) {
                setState(() {
                  unameMsg = "";
                  emailMsg = "";
                  if (fnameRegisCtrl.trim() == "") {
                    fnameMsg = "First Name can't be empty";
                  } else {
                    fnameMsg = "";
                  }
                  if (passRegisCtrl.trim() == "") {
                    passMsg = "Password can't be empty";
                  } else {
                    passMsg = "";
                  }
                });
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => const FailedDialog(
                        text: "Please fill the remaining field",
                        type: "register"));
              } else {
                if (usernameAvaiabilityCheck.trim() == "" ||
                    emailAvaiabilityCheck.trim() == "") {
                  setState(() {
                    if (usernameAvaiabilityCheck.trim() == "") {
                      unameMsg = "Username can't be empty";
                    }
                    if (emailAvaiabilityCheck.trim() == "") {
                      emailMsg = "Email can't be empty";
                    }
                  });
                } else {
                  setState(() {
                    unameMsg = "Username is invalid";
                    emailMsg = "Email is invalid";
                  });
                }

                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => const FailedDialog(
                        text: "Please register your account first",
                        type: "register"));
              }
            }
          } else if (!isCheckedRegister && indexRegis == 1) {
            setState(() {
              checkMsg = "You haven't accept the terms & condition";
            });
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => const FailedDialog(
                    text: "You haven't accept the terms & condition",
                    type: "register"));
          } else {
            setState(() {
              if (isCheckedRegister) {
                checkMsg = "";
              }
              setIndex(indexRegis++);
            });
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
              'Next',
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
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      contentPadding: const EdgeInsets.all(10),
                      title: Text('Warning'.tr),
                      content: SizedBox(
                        width: width,
                        height: 75,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                      "Are you sure want to close the registration?"
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: shadowColor,
                                          fontSize: textXMD)))
                            ]),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(roundedSM),
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(warningBG),
                          ),
                          onPressed: () async {
                            indexRegis = 0;
                            usernameAvaiabilityCheck = "";
                            emailAvaiabilityCheck = "";
                            passRegisCtrl = "";
                            fnameRegisCtrl = "";
                            lnameRegisCtrl = "";
                            validRegisCtrl = 2023;
                            isCheckedRegister = false;
                            isFillForm = false;
                            isChooseRole = false;
                            checkAvaiabilityRegis = false;
                            isFinishedRegis = false;
                            uploadedImageRegis = null;
                            isWaiting = false;
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();

                            Get.offAll(() => const LoginPage());
                          },
                          child: Text("Yes".tr,
                              style: TextStyle(color: whiteColor)),
                        )
                      ],
                    ));
          } else {
            setState(() {
              setIndex(indexRegis--);
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
        onTap: () {
          Get.offAll(() => const LoginPage());
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
            child: const GetWelcoming()),
      ),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.0,
                color: Colors.transparent,
              ),
            ),
            child: GetTerms(checkMsg: checkMsg)),
      ),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(width: 0.0, color: Colors.transparent),
            ),
            child: SetProfileData(
              allMsg: allMsg,
              fnameMsg: fnameMsg,
              lnameMsg: lnameMsg,
              emailMsg: emailMsg,
              passMsg: passMsg,
              unameMsg: unameMsg,
            )),
      ),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.0,
                color: Colors.transparent,
              ),
            ),
            child: const SetProfileImage()),
      ),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.0,
                color: Colors.transparent,
              ),
            ),
            child: const SetRole()),
      ),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.0,
                color: Colors.transparent,
              ),
            ),
            child: const GetWaiting()),
      ),
    ];

    return WillPopScope(
        onWillPop: () async {
          // Do something LOL
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Onboarding(
              pages: onboardingPagesList,
              onPageChange: (int pageIndex) {
                setState(() {
                  indexRegis = pageIndex;
                });
              },
              startPageIndex: indexRegis,
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
                          indexRegis == 0
                              ? _backButton(
                                  setIndex: setIndex,
                                  isFirst: true,
                                  width: fullWidth)
                              : indexRegis != 0 && indexRegis != pagesLength - 1
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
                              closedIndicator:
                                  ClosedIndicator(color: primaryColor),
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
                          indexRegis == pagesLength - 1
                              ? finishBtn()
                              : _skipButton(
                                  setIndex: setIndex, height: fullHeight)
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
