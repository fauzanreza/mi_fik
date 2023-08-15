import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/sign_out_dialog.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getSignOutButtonWide(var ctx) {
  return InkWell(
      onTap: () {
        Get.dialog(const SignOutDialog());
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: spaceLG, horizontal: spaceSM - 5),
        padding: EdgeInsets.symmetric(horizontal: spaceLG, vertical: spaceXMD),
        decoration: BoxDecoration(
            color: warningBG,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(children: [
          Icon(Icons.logout, size: iconMD, color: whiteColor),
          const Spacer(),
          Text("Log-Out".tr,
              style: TextStyle(
                  fontSize: textXMD,
                  fontWeight: FontWeight.w500,
                  color: whiteColor)),
          const Spacer(),
          const SizedBox(width: 10)
        ]),
      ));
}

getSpeeDialChild(String title, var ctx, var cls, IconData icon, String desc) {
  return SpeedDialChild(
      child: Icon(icon),
      // label: title,
      // labelStyle: TextStyle(fontSize: textXMD, color: whiteColor),
      // labelBackgroundColor: primaryColor,
      labelWidget: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        width: Get.width * 0.8,
        margin: EdgeInsets.only(right: spaceSM, top: spaceSM),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.35),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
              )
            ],
            color: successBG,
            border: Border.all(color: whiteColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(roundedMD))),
        padding: EdgeInsets.symmetric(vertical: spaceXSM, horizontal: spaceMD),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            title,
            style: TextStyle(
                fontSize: textMD,
                color: whiteColor,
                letterSpacing: 0.75,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: spaceMini),
          Text(
            desc,
            style: TextStyle(
                fontSize: textSM,
                color: whiteColor,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          )
        ]),
      ),
      backgroundColor: successBG,
      foregroundColor: whiteColor,
      onTap: () => showModalBottomSheet(
            context: ctx,
            isDismissible: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(roundedLG),
                    topRight: Radius.circular(roundedLG))),
            barrierColor: primaryColor.withOpacity(0.5),
            isScrollControlled: true,
            builder: (BuildContext context) {
              return cls;
            },
          ));
}

Widget getSideBarTile(double width, IconData icon, String title, var action) {
  return Container(
    width: width,
    margin: EdgeInsets.only(left: spaceSM, right: spaceSM),
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      onPressed: action,
      icon: Icon(icon, size: textLG, color: whiteColor),
      label: Text(title,
          style: TextStyle(color: whiteColor, fontSize: textXMD + 2)),
      style: ElevatedButton.styleFrom(),
    ),
  );
}

Widget outlinedButtonCustom(var action, String title, IconData icon) {
  return TextButton.icon(
    onPressed: action,
    label: Text(title,
        style: TextStyle(
            color: warningBG, fontSize: textXMD, fontWeight: FontWeight.w500)),
    icon: Icon(icon, color: warningBG),
  );
}

Widget getProfileButton(
    var action, IconData iconStart, String title, IconData iconEnd) {
  return InkWell(
      onTap: action,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: hoverBG, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: spaceXMD, vertical: spaceLG),
            child: Row(
              children: [
                Icon(iconStart, color: shadowColor, size: iconLG),
                const SizedBox(width: 35),
                Text(title, style: TextStyle(fontSize: textXMD)),
                const Spacer(),
                Icon(iconEnd, color: shadowColor, size: iconLG),
              ],
            )),
      ));
}
