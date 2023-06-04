import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_terms.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_waiting.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/get_welcoming.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_profile_data.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_profile_image.dart';
import 'package:mi_fik/Pages/Landings/RegisterPage/Usecases/set_role.dart';
import 'package:onboarding/onboarding.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  Material materialButton;
  int index;

  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: const GetWelcoming()),
    ),
    PageModel(
      widget: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: const GetTerms()),
    ),
    PageModel(
      widget: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: SetProfileData()),
    ),
    PageModel(
      widget: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: SetProfileImage()),
    ),
    PageModel(
      widget: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: const SetRole()),
    ),
    PageModel(
      widget: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: const GetWaiting()),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int) setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: successbg,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 2;
            setIndex(2);
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
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

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
              index = pageIndex;
            },
            startPageIndex: 0,
            footerBuilder: (context, dragDistance, pagesLength, setIndex) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(
                    width: 0.0,
                    color: background,
                  ),
                ),
                child: ColoredBox(
                  color: background,
                  child: Padding(
                    padding: const EdgeInsets.all(45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIndicator(
                          netDragPercent: dragDistance,
                          pagesLength: pagesLength,
                          indicator: Indicator(
                            indicatorDesign: IndicatorDesign.line(
                              lineDesign: LineDesign(
                                lineType: DesignType.line_uniform,
                              ),
                            ),
                          ),
                        ),
                        index == pagesLength - 1
                            ? _signupButton
                            : _skipButton(setIndex: setIndex)
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
