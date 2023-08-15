import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.all(spaceSM),
      title: null,
      content: SizedBox(
        width: fullWidth,
        height: 320,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(roundedJumbo + roundedJumbo),
                child: Image.asset('assets/icon/Success.png', width: 120),
              ),
              SizedBox(height: spaceLG),
              Text("Success".tr,
                  style: TextStyle(
                      color: darkColor,
                      fontSize: textLG,
                      fontWeight: FontWeight.bold)),
              Container(
                  margin: EdgeInsets.fromLTRB(0, spaceMini, 0, spaceSM),
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: shadowColor,
                          fontSize: textXMD,
                          fontWeight: FontWeight.w500))),
              Divider(
                height: spaceMD,
                color: greyColor,
              ),
              InkWell(
                  onTap: () => Navigator.pop(context, 'OK'),
                  child: Container(
                    padding: EdgeInsets.all(spaceMD),
                    margin: EdgeInsets.only(top: spaceMD),
                    decoration: BoxDecoration(
                        color: successBG,
                        borderRadius:
                            BorderRadius.all(Radius.circular(roundedMD))),
                    child: Text("OK".tr,
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.w500)),
                  ))
            ]),
      ),
    );
  }
}

class SuccessDialogCustom extends StatelessWidget {
  const SuccessDialogCustom({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: fullWidth * 0.45,
            padding: EdgeInsets.all(fullWidth * 0.1),
            margin: EdgeInsets.only(bottom: spaceMD),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              child: Image.asset('assets/icon/checklist.png'),
            ),
          ),
          Text(text,
              style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: textLG + 4))
        ]));
  }
}
