import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
        margin: EdgeInsets.symmetric(
            vertical: paddingMD, horizontal: paddingXSM - 5),
        padding:
            EdgeInsets.symmetric(horizontal: paddingMD, vertical: paddingSM),
        decoration: BoxDecoration(
            color: dangerColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(children: [
          Icon(Icons.logout, size: iconMD, color: whitebg),
          const Spacer(),
          Text("Log-Out",
              style: TextStyle(
                  fontSize: textMD,
                  fontWeight: FontWeight.w500,
                  color: whitebg)),
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
    foregroundColor: whitebg,
    onTap: () {
      showModalBottomSheet<void>(
        context: ctx,
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topLeft: roundedLG, topRight: roundedLG)),
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
    margin: EdgeInsets.only(left: paddingXSM, right: paddingXSM),
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      onPressed: action,
      icon: Icon(icon, size: textXLG, color: whitebg),
      label: Text(title, style: TextStyle(color: whitebg, fontSize: textMD)),
      style: ElevatedButton.styleFrom(),
    ),
  );
}

Widget outlinedButtonCustom(var action, String title, IconData icon) {
  return TextButton.icon(
    onPressed: action,
    label: Text(title,
        style: TextStyle(
            color: dangerColor, fontSize: textMD, fontWeight: FontWeight.w500)),
    icon: Icon(icon, color: dangerColor),
  );
}

Widget getProfileButton(
    var action, IconData iconStart, String title, IconData iconEnd) {
  return InkWell(
      onTap: action,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: mainbg, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: paddingSM, vertical: paddingMD),
            child: Row(
              children: [
                Icon(iconStart, color: greybg, size: iconMD * 0.8),
                const SizedBox(width: 35),
                Text(title, style: TextStyle(fontSize: textMD - 1)),
                const Spacer(),
                Icon(iconEnd, color: greybg, size: iconMD * 0.8),
              ],
            )),
      ));
}
