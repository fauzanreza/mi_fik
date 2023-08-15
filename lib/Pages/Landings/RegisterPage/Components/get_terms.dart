import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetTerms extends StatefulWidget {
  const GetTerms({Key key, this.checkMsg}) : super(key: key);
  final String checkMsg;

  @override
  StateGetTerms createState() => StateGetTerms();
}

class StateGetTerms extends State<GetTerms> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    //double fullHeight = MediaQuery.of(context).size.height;

    return ListView(
      padding:
          EdgeInsets.fromLTRB(spaceLG, spaceJumbo + spaceMD, spaceLG, spaceLG),
      children: [
        getTitleLarge("Terms & Condition".tr, primaryColor),
        Text(
            "Welcome to the Faculty of Creative Industries Information Management Application (MI-FIK). Before using this application, please read and understand carefully the following terms and conditions of use:"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        const SizedBox(height: 10),
        Text("Legal Compliance:".tr,
            style: TextStyle(fontSize: textXMD, fontWeight: FontWeight.bold)),
        Text(
            "1. By Using this application, you agree to comply with all applicable laws and regulations in your jurisdiction related to the use of this application"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        Text(
            "2. Take full responsibility for any activities conducted through your account in this app"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        const SizedBox(height: 10),
        //
        Text("Privacy and Security:".tr,
            style: TextStyle(fontSize: textXMD, fontWeight: FontWeight.bold)),
        Text(
            "1. We respect your privacy and are committed to protecting the personal data you provide"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        Text(
            "2. You are responsible for maintaining the confidentiality and security of your account. Do not provide your login information to other parties and be sure to log out of your account when finished using the application"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        const SizedBox(height: 10),
        //
        Text("User Content:".tr,
            style: TextStyle(fontSize: textXMD, fontWeight: FontWeight.bold)),
        Text(
            "1. When using this app, you agree not to upload, share, or distribute content that is unlawful, infringes intellectual property rights, or violates the privacy of others"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        Text(
            "2. You are solely responsible for the content you share through this app. We are not responsible for inappropriate user content"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        const SizedBox(height: 10),
        //
        Text("Changes and Updates:".tr,
            style: TextStyle(fontSize: textXMD, fontWeight: FontWeight.bold)),
        Text(
            "1. We reserve the right to change or update these terms and conditions from time to time without prior notice. Please be sure to check this page periodically to keep up to date with the latest information"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        Text(
            "2. In case of important changes, we will provide notice to users through appropriate communication channels"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        const SizedBox(height: 10),
        //
        Text("Limitation of Liability:".tr,
            style: TextStyle(fontSize: textXMD, fontWeight: FontWeight.bold)),
        Text(
            '1. This app is provided "as is" and we do not make any warranties or representations regarding the accuracy, reliability, or availability of this app'
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        Text(
            "2. We are not liable for any loss or damage arising from the use of this app or the inability to use it"
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        SizedBox(height: spaceLG),
        Text(
            "By agreeing to the terms and conditions in using the MI-FIK application, you agree and accept all the terms and conditions listed above. If you do not agree with these terms and conditions, please stop using this application. If you have any questions or concerns, please feel free to contact our support team."
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        Row(children: [
          Checkbox(
            checkColor: whiteColor,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isCheckedRegister,
            onChanged: (bool value) {
              setState(() {
                isCheckedRegister = value;
              });
            },
          ),
          Container(
              constraints: BoxConstraints(maxWidth: fullWidth * 0.6),
              margin: EdgeInsets.only(top: spaceSM),
              child: Text(
                  "I agree to the terms and condition on this app, Thank you for your understanding and cooperation"
                      .tr,
                  style: TextStyle(fontSize: textXMD - 2.5)))
        ]),
        getInputWarning(widget.checkMsg),
      ],
    );
  }
}
