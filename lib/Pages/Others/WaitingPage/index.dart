import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key key}) : super(key: key);

  @override
  StateWaitingPage createState() => StateWaitingPage();
}

class StateWaitingPage extends State<WaitingPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async {
          // Do something LOL
          return false;
        },
        child: Scaffold(
            body: CustomPaint(
                painter: CirclePainterSide(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: paddingXSM, horizontal: paddingMD),
                      margin: EdgeInsets.all(paddingMD * 2.5),
                      decoration: BoxDecoration(
                        color: whitebg,
                        borderRadius: BorderRadius.all(roundedLG),
                      ),
                      child: ClipRRect(
                        child: Image.asset('assets/icon/sorry.png'),
                      ),
                    ),
                    getTitleJumbo("Waiting for Approval...", whitebg),
                    Text("Soon, our Admin will give you access to the App",
                        style: TextStyle(color: whitebg, fontSize: textMD)),
                    Text("It may take to 1-2 hr, please waiting",
                        style: TextStyle(color: whitebg, fontSize: textMD)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: paddingMD),
                      child: getTitleJumbo("Or", whitebg),
                    ),
                    InkWell(
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
                        height: 60,
                        width: 60,
                        padding: EdgeInsets.all(paddingXSM - 2),
                        decoration: BoxDecoration(
                            color: successbg,
                            border: Border.all(color: whitebg, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100))),
                        child: IconButton(
                          icon: const Icon(Icons.mail),
                          color: whitebg,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
