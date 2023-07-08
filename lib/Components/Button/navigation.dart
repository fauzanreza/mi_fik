import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/sign_out_dialog.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getSignOutButtonWide(var ctx) {
  return InkWell(
      onTap: () {
        showDialog<String>(
            context: ctx,
            builder: (BuildContext context) => const SignOutDialog());
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
                  fontSize: textMD,
                  fontWeight: FontWeight.w500,
                  color: whiteColor)),
          const Spacer(),
          const SizedBox(width: 10)
        ]),
      ));
}

getSpeeDialChild(String title, var ctx, var cls, var icon) {
  return SpeedDialChild(
    child: Icon(icon),
    label: title,
    backgroundColor: primaryColor,
    foregroundColor: whiteColor,
    onTap: () {
      showModalBottomSheet<void>(
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
      );
    },
  );
}

Widget getSideBarTile(double width, IconData icon, String title, var action) {
  return Container(
    width: width,
    margin: EdgeInsets.only(left: spaceSM, right: spaceSM),
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      onPressed: action,
      icon: Icon(icon, size: textXLG, color: whiteColor),
      label: Text(title, style: TextStyle(color: whiteColor, fontSize: textMD)),
      style: ElevatedButton.styleFrom(),
    ),
  );
}

Widget outlinedButtonCustom(var action, String title, IconData icon) {
  return TextButton.icon(
    onPressed: action,
    label: Text(title,
        style: TextStyle(
            color: warningBG, fontSize: textMD, fontWeight: FontWeight.w500)),
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
                Text(title, style: TextStyle(fontSize: textMD - 1)),
                const Spacer(),
                Icon(iconEnd, color: shadowColor, size: iconLG),
              ],
            )),
      ));
}
