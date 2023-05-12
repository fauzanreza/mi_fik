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
            vertical: paddingMD * 2, horizontal: paddingXSM - 5),
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

Widget OutlinedButtonCustom(var action, String title) {
  return TextButton.icon(
    onPressed: action,
    label: Text('Back to Archive',
        style: TextStyle(
            color: dangerColor, fontSize: textMD, fontWeight: FontWeight.w500)),
    icon: Icon(Icons.arrow_back, color: dangerColor),
  );
}
