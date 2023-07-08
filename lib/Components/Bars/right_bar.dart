import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/Usecases/get_notif.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class RightBar extends StatelessWidget {
  const RightBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Drawer(
        child: Container(
            padding: EdgeInsets.only(top: fullWidth * 0.15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, semidarkColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    margin: EdgeInsets.only(left: spaceXLG),
                    child: Text("Notification".tr,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: textXMD,
                            fontWeight: FontWeight.w500))),
                const Expanded(
                  child: GetNotification(),
                )
              ],
            )));
  }
}
