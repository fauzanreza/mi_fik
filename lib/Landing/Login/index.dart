import 'package:flutter/material.dart';
import 'package:mi_fik/Others/custombg.dart';
import 'package:mi_fik/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: primaryColor,
        body: CustomPaint(
            painter: CirclePainterSide(),
            child: ListView(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 30, horizontal: paddingSM),
                  margin: EdgeInsets.symmetric(
                      horizontal: 20, vertical: fullHeight * 0.1),
                  decoration: BoxDecoration(
                    color: whitebg,
                    borderRadius: BorderRadius.all(roundedLG),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            child: Image.asset('assets/icon/mifik_logo.png',
                                width: 300),
                          ),
                        ),
                        Text("Username",
                            style: TextStyle(color: blackbg, fontSize: textMD)),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: paddingXSM),
                          padding: EdgeInsets.only(top: paddingXSM * 0.5),
                          child: TextField(
                            cursorColor: blackbg,
                            maxLength: 75, //Check this!!!
                            autofocus: true,
                            decoration: InputDecoration(
                              fillColor: mainbg,
                              filled: true,
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Text("Password",
                            style: TextStyle(color: blackbg, fontSize: textMD)),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: paddingXSM),
                          padding: EdgeInsets.only(top: paddingXSM * 0.5),
                          child: TextField(
                            cursorColor: blackbg,
                            maxLength: 75, //Check this!!!
                            autofocus: true,
                            decoration: InputDecoration(
                              fillColor: mainbg,
                              filled: true,
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.zero,
                            width: fullWidth,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                //Do something
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(roundedLG2),
                                )),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        primaryColor),
                              ),
                              child: const Text('Sign In'),
                            ))
                      ]),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: paddingXSM, horizontal: paddingMD),
                  margin: EdgeInsets.only(
                      left: fullWidth * 0.2,
                      right: fullWidth * 0.2,
                      top: 20,
                      bottom: 20),
                  decoration: BoxDecoration(
                    color: whitebg,
                    borderRadius: BorderRadius.all(roundedLG),
                  ),
                  child: ClipRRect(
                    child: Image.asset('assets/icon/fik_logo.png'),
                  ),
                )
              ],
            )));
  }
}
