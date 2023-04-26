import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Dialogs/sign_out_dialog.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getSignOutButtonWide(var ctx) {
  return InkWell(
      onTap: () {
        showDialog<String>(
            context: ctx, builder: (BuildContext context) => SignOutDialog());
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
