import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/nodata_dialog.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
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
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  Material materialButton;

  UserCommandsService apiService;

  @override
  void initState() {
    super.initState();
    apiService = UserCommandsService();
    materialButton = _skipButton();
    indexRegis = 0;
  }

  Material _skipButton({void Function(int) setIndex, double height}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: successbg,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (selectedRole.isEmpty && !isChooseRole && indexRegis == 5) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    NoDataDialog(text: "You haven't selected any tag yet"));
          } else if (selectedRole.isNotEmpty &&
              !isChooseRole &&
              indexRegis == 5) {
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
                    child: PostSelectedRole(back: null));
              },
            );
          } else if (selectedRole.isEmpty && !isFillForm && indexRegis == 3) {
            RegisterModel data = RegisterModel(
              username: usernameAvaiabilityCheck.trim(),
              email: emailAvaiabilityCheck.trim(),
            );

            Map<String, dynamic> valid = UserValidator.validateRegis(data);
            if (valid['status']) {
              apiService.postUser(data).then((response) {
                var status = response[0]['message'];
                var body = response[0]['body'];

                if (status == "success") {
                  isFillForm = true;

                  Get.snackbar("Success", "Account has been registered",
                      backgroundColor: whitebg);
                } else {
                  isFillForm = false;

                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          FailedDialog(text: body, type: "register"));
                }
              });
            }
          } else {
            setIndex(indexRegis++);
          }
        },
        child: Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Next',
            style: TextStyle(fontSize: textMD, color: whitebg),
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
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
    //double fullWidth = MediaQuery.of(context).size.width;
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
            child: const GetTerms()),
      ),
      PageModel(
        widget: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(width: 0.0, color: Colors.transparent),
            ),
            child: const SetProfileData()),
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
            body: CustomPaint(
          painter: CirclePainterSide(),
          child: Onboarding(
            pages: onboardingPagesList,
            onPageChange: (int pageIndex) {
              indexRegis = pageIndex;
            },
            startPageIndex: 0,
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
                            activeIndicator: ActiveIndicator(color: whitebg),
                            closedIndicator: ClosedIndicator(color: successbg),
                            indicatorDesign: IndicatorDesign.polygon(
                              polygonDesign: PolygonDesign(
                                polygon: DesignType.polygon_circle,
                              ),
                            ),
                          ),
                        ),
                        indexRegis == pagesLength
                            ? _signupButton
                            : _skipButton(
                                setIndex: setIndex, height: fullHeight)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )));
  }
}
