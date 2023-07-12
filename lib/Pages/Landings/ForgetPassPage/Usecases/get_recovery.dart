import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

// ignore: must_be_immutable
class GetRecovery extends StatefulWidget {
  GetRecovery({Key key, this.unameMsg, this.emailMsg}) : super(key: key);
  String unameMsg = "";
  String emailMsg = "";

  @override
  StateGetRecovery createState() => StateGetRecovery();
}

class StateGetRecovery extends State<GetRecovery>
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
    double fullHeight = MediaQuery.of(context).size.height;

    Widget getDataDetailForm(bool status) {
      if (status && !successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Username", darkColor, TextAlign.left),
            getInputWarning(widget.unameMsg),
            getInputTextRegis(30, "username", usernameCtrl, refresh,
                usernameAvaiabilityCheck, isCheckedRegister),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", emailCtrl, refresh,
                emailAvaiabilityCheck, isCheckedRegister),
            Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: Image.asset('assets/icon/send_email.png',
                      width: fullHeight * 0.25),
                )),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "We've send you password recovery token to your email. Please check it",
                  style: TextStyle(fontSize: textMD),
                )),
          ],
        );
      } else if (status && successValidateAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSubTitleMedium("Username", darkColor, TextAlign.left),
            getInputWarning(widget.unameMsg),
            getInputTextRegis(30, "username", usernameCtrl, refresh,
                usernameAvaiabilityCheck, isFillForm),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", emailCtrl, refresh,
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
            getSubTitleMedium("Username", darkColor, TextAlign.left),
            getInputWarning(widget.unameMsg),
            getInputTextRegis(30, "username", usernameCtrl, refresh,
                usernameAvaiabilityCheck, isFillForm),
            getSubTitleMedium("Email", darkColor, TextAlign.left),
            getInputWarning(widget.emailMsg),
            getInputTextRegis(30, "email", emailCtrl, refresh,
                emailAvaiabilityCheck, isFillForm),
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
                  onPressed: () {},
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
          getDataDetailForm(checkAvaiabilityRegis),
        ]);
  }
}
