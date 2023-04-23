import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/Usecases/GetNotification.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class RightBar extends StatelessWidget {
  const RightBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Drawer(
        backgroundColor: primaryColor,
        child: Container(
            width: fullWidth,
            margin: EdgeInsets.only(top: fullHeight * 0.075),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: marginMD),
                    child: Text("Notification",
                        style: TextStyle(
                            color: whitebg,
                            fontSize: textLG,
                            fontWeight: FontWeight.w500))),
                Expanded(
                    child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Text("Today",
                            style: TextStyle(
                                color: whitebg,
                                fontSize: textMD,
                                fontWeight: FontWeight.w500))),
                    GetNotification()
                  ],
                ))
              ],
            )));
  }
}
