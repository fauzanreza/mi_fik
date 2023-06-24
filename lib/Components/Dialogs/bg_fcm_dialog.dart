import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class BgFcmDialog extends StatelessWidget {
  const BgFcmDialog({Key key, this.title, this.body}) : super(key: key);
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        insetPadding: EdgeInsets.all(paddingXSM),
        contentPadding: EdgeInsets.all(paddingXSM),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.all(roundedLG)),
        content: SizedBox(
            height: fullHeight * 0.75,
            width: fullWidth,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: paddingXSM),
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: paddingLg,
                  ),
                  Text(body),
                  SizedBox(
                    height: paddingLg,
                  ),
                ],
              )),
            ])));
  }
}
