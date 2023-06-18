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
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_terms.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_waiting.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_welcoming.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_profile_data.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_profile_image.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_role.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/post_selected_role.dart';
import 'package:onboarding/onboarding.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.isLogged}) : super(key: key);
  bool isLogged;

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
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
    apiService = UserCommandsService();
    apiQuery = UserQueriesService();

    authService = AuthCommandsService();
    materialButton = _skipButton();
  }

  Widget _skipButton({void Function(int) setIndex, double height}) {
    return InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () async {
          if (selectedRole.isEmpty && !isChooseRole && indexRegis == 4) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    NoDataDialog(text: "You haven't selected any tag yet"));
          } else if (selectedRole.isNotEmpty &&
              !isChooseRole &&
              indexRegis == 4) {
            showModalBottomSheet<void>(
              context: context,
              isDismissible: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: roundedLG, topRight: roundedLG)),
              barrierColor: primaryColor.withOpacity(0.5),
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                    height: height * 0.4,
                    padding: MediaQuery.of(context).viewInsets,
                    child: PostSelectedRole(back: null, isLogged: false));
              },
            );
          } else if (selectedRole.isEmpty && !isFillForm && indexRegis == 2) {
            if (usernameAvaiabilityCheck.trim() != "" &&
                emailAvaiabilityCheck.trim() != "" &&
                passRegisCtrl.trim() != "" &&
                fnameRegisCtrl.trim() != "" &&
                lnameRegisCtrl.trim() != "") {
              RegisterModel regisData = RegisterModel(
                  username: usernameAvaiabilityCheck.trim(),
                  email: emailAvaiabilityCheck.trim(),
                  password: passRegisCtrl.trim(),
                  firstName: fnameRegisCtrl.trim(),
                  lastName: lnameRegisCtrl.trim(),
                  validUntil: 2024 // fow now
                  );

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
                      setIndex(indexRegis++);
                      setState(() {
                        fnameMsg = "";
                        lnameMsg = "";
                        passMsg = "";
                        allMsg = "";
                        isFillForm = true;
                      });

                      Get.snackbar("Success", "Account has been registered",
                          backgroundColor: whitebg);
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
                  if (lnameRegisCtrl.trim() == "") {
                    lnameMsg = "Last Name can't be empty";
                  } else {
                    lnameMsg = "";
                  }
                  if (passRegisCtrl.trim() == "") {
                    passMsg = "Password can't be empty";
                  } else {
                    passMsg = "";
                  }
                });
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => FailedDialog(
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
                    builder: (BuildContext context) => FailedDialog(
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
                builder: (BuildContext context) => FailedDialog(
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
          padding: EdgeInsets.symmetric(
              horizontal: paddingMD, vertical: paddingSM * 0.5),
          decoration: BoxDecoration(
              color: whitebg,
              border: Border.all(color: successbg, width: 2),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
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
              color: successbg,
            ),
            SizedBox(
              width: paddingSM,
            ),
            Text(
              'Next',
              style: TextStyle(
                  fontSize: textMD,
                  color: successbg,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ));
  }

  Widget _signupButton() {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: successbg,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {},
        child: Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Explore Now',
            style: TextStyle(fontSize: textMD, color: whitebg),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;

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
                  padding: const EdgeInsets.all(45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          closedIndicator: ClosedIndicator(color: primaryColor),
                          activeIndicator:
                              ActiveIndicator(color: greybg.withOpacity(0.25)),
                          indicatorDesign: IndicatorDesign.polygon(
                            polygonDesign: PolygonDesign(
                              polygon: DesignType.polygon_circle,
                            ),
                          ),
                        ),
                      ),
                      indexRegis == pagesLength
                          ? _signupButton()
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
