import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class GetValidate extends StatefulWidget {
  GetValidate({Key key, this.passMsg, this.tokenMsg}) : super(key: key);
  String passMsg = "";
  String tokenMsg = "";

  @override
  StateGetValidate createState() => StateGetValidate();
}

class StateGetValidate extends State<GetValidate>
    with SingleTickerProviderStateMixin {
  AnimationController lottieController;
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(vsync: this);
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
    // double fullHeight = MediaQuery.of(context).size.height;

    Widget getDataDetailForm(bool status) {
      if (status && !successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Token", darkColor, TextAlign.left),
            getInputWarning(widget.tokenMsg),
            getSubTitleMedium("New Password", darkColor, TextAlign.left),
            getInputWarning(widget.passMsg),
            getInputTextRegis(30, "password", emailCtrl, refresh,
                emailAvaiabilityCheck, isFillForm),
          ],
        );
      } else if (status && successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Token", darkColor, TextAlign.left),
            getInputWarning(widget.tokenMsg),
            getSubTitleMedium("New Password", darkColor, TextAlign.left),
            getInputWarning(widget.passMsg),
            getInputTextRegis(30, "password", emailCtrl, refresh,
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
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: getSubTitleMedium("Token", darkColor, TextAlign.center)),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 40,
                    height: 40,
                    textStyle: TextStyle(
                        fontSize: textLG,
                        color: darkColor,
                        fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(234, 239, 243, 1)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onCompleted: (pin) => print(pin),
                )),
            getInputWarning(widget.tokenMsg),
            Container(
                margin: EdgeInsets.only(top: spaceXMD),
                alignment: Alignment.center,
                child: Text(
                  "You have 15 minutes to validate the token",
                  style: TextStyle(fontSize: textMD),
                )),
          ],
        );
      }
    }

    return ListView(
        padding: EdgeInsets.fromLTRB(
            spaceLG, spaceJumbo + spaceXMD, spaceLG, spaceLG),
        children: [
          getTitleLarge("Set your new password", primaryColor),
          getDataDetailForm(checkAvaiabilityRegis),
        ]);
  }
}
