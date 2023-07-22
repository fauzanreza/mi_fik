import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetWaiting extends StatefulWidget {
  const GetWaiting({Key key}) : super(key: key);

  @override
  StateGetWaiting createState() => StateGetWaiting();
}

class StateGetWaiting extends State<GetWaiting> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        Container(
            height: fullHeight * 0.75,
            padding: EdgeInsets.symmetric(
                horizontal: spaceLG, vertical: spaceJumbo * 2),
            margin: EdgeInsets.fromLTRB(spaceLG, spaceJumbo, spaceLG, spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getTitleLarge("Your account has registered", primaryColor),
                ClipRRect(
                  child: Image.asset('assets/icon/usermanage.png',
                      width: fullHeight * 0.3),
                ),
                getSubTitleMedium(
                    "Please wait until your account has been approved by admin",
                    darkColor,
                    TextAlign.center),
                Center(
                    child: InkWell(
                  onTap: () async {
                    final Email email = Email(
                      body:
                          'Hey, I want to regist to Mi-Fik, please accept my request',
                      subject: 'Account Register',
                      recipients: ['hello@mifik.id'],
                      // cc: ['cc@example.com'],
                      // bcc: ['bcc@example.com'],
                      // attachmentPaths: ['/path/to/attachment.zip'],
                      isHTML: false,
                    );

                    await FlutterEmailSender.send(email);
                  },
                  child: Container(
                    width: 180,
                    margin: EdgeInsets.only(top: spaceLG),
                    padding: EdgeInsets.all(spaceSM),
                    decoration: BoxDecoration(
                        color: successBG,
                        border: Border.all(color: whiteColor, width: 2),
                        borderRadius:
                            BorderRadius.all(Radius.circular(roundedLG))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mail, color: whiteColor),
                          SizedBox(width: spaceLG),
                          Text("Send Email".tr,
                              style: TextStyle(
                                fontSize: textXMD,
                                color: whiteColor,
                              ))
                        ]),
                  ),
                )),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: spaceLG),
                      child: getTitleJumbo("Or".tr, whiteColor),
                    )),
              ],
            ))
      ],
    );
  }
}
