import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class BgFcmDialog extends StatelessWidget {
  const BgFcmDialog({Key key, this.title, this.body, this.date})
      : super(key: key);
  final String title;
  final String body;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        insetPadding: EdgeInsets.all(spaceSM),
        contentPadding: EdgeInsets.all(spaceSM),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(roundedLG))),
        content: SizedBox(
            height: fullHeight * 0.75,
            width: fullWidth,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(getItemTimeString(date),
                    style: TextStyle(fontSize: textXMD, color: primaryColor)),
                const Spacer(),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Back',
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ]),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: spaceMini),
                  child: Divider(
                      thickness: 1, indent: spaceLG, endIndent: spaceLG)),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: spaceSM),
                children: [
                  Text(ucFirst(title),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: textXMD)),
                  SizedBox(
                    height: spaceJumbo,
                  ),
                  Text(body,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: textXMD)),
                  SizedBox(
                    height: spaceJumbo,
                  )
                ],
              )),
            ])));
  }
}
