import 'package:flutter/material.dart';
import 'package:mi_fik/Others/custombg.dart';
import 'package:mi_fik/main.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key key}) : super(key: key);

  @override
  _IntroPage createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> {
  int _index = 0;
  final role = [
    {"id": 0, "role_name": "Lecturer"},
    {"id": 1, "role_name": "Staff"},
    {"id": 2, "role_name": "Student"},
    {"id": 3, "role_name": "Unit"}
  ];

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: CustomPaint(
            painter: CirclePainterSideWhite(),
            child: ListView(
              padding: EdgeInsets.symmetric(
                  vertical: fullHeight * 0.3, horizontal: 20),
              children: [
                Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Theme(
                          data: ThemeData(
                            canvasColor: mainbg,
                          ),
                          child: Stepper(
                              controlsBuilder: (context, onStepContinue) {
                                return Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_index <= 1) {
                                              setState(() {
                                                _index += 1;
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
                                                EdgeInsets.symmetric(
                                                    vertical: paddingXSM,
                                                    horizontal:
                                                        paddingMD * 2.4)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      roundedLG2),
                                            )),
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    primaryColor),
                                          ),
                                          child: Text('Next',
                                              style:
                                                  TextStyle(fontSize: textMD)),
                                        )
                                        //Need back button??
                                      ],
                                    ));
                              },
                              type: StepperType.horizontal,
                              physics: const ClampingScrollPhysics(),
                              currentStep: _index,
                              onStepCancel: () {
                                if (_index > 0) {
                                  setState(() {
                                    _index -= 1;
                                  });
                                }
                              },
                              onStepContinue: () {
                                if (_index <= 1) {
                                  setState(() {
                                    _index += 1;
                                  });
                                }
                              },
                              onStepTapped: (int index) {
                                setState(() {
                                  _index = index;
                                });
                              },
                              steps: <Step>[
                                Step(
                                    title: Text('',
                                        style: TextStyle(color: primaryColor)),
                                    content: Column(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          child: Image.asset(
                                              'assets/icon/mifik_logo.png',
                                              width: 300),
                                        ),
                                      ),
                                      Text("Welcome to MI-FIK",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textLG,
                                              fontWeight: FontWeight.w500)),
                                      Text("Every Information in one app",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textLG,
                                              fontWeight: FontWeight.w500)),
                                    ])),
                                Step(
                                    title: Text('',
                                        style: TextStyle(color: primaryColor)),
                                    content: Column(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          child: Image.asset(
                                              'assets/icon/mifik_logo.png',
                                              width: 300),
                                        ),
                                      ),
                                      Text("Manage your Task",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textLG,
                                              fontWeight: FontWeight.w500)),
                                      Text("and Activity",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textLG,
                                              fontWeight: FontWeight.w500)),
                                    ])),
                                Step(
                                    title: Text('',
                                        style: TextStyle(color: primaryColor)),
                                    content: Column(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          child: Image.asset(
                                              'assets/icon/mifik_logo.png',
                                              width: 300),
                                        ),
                                      ),
                                      Text("Please tell us who You are",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textLG,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: Wrap(
                                              runSpacing: -5,
                                              spacing: 5,
                                              children: role.map<Widget>(
                                                (rl) {
                                                  return OutlinedButton(
                                                    onPressed: () {},
                                                    child: Text(rl['role_name'],
                                                        style: TextStyle(
                                                            color:
                                                                primaryColor)),
                                                    style: ButtonStyle(
                                                      side: MaterialStateProperty
                                                          .all(BorderSide(
                                                              color:
                                                                  primaryColor,
                                                              width: 1.5,
                                                              style: BorderStyle
                                                                  .solid)),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    roundedLG2),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                              Color>(mainbg),
                                                    ),
                                                  );
                                                },
                                              )))
                                    ])),
                                Step(
                                    title: Text('',
                                        style: TextStyle(color: primaryColor)),
                                    content: Column(children: []))
                              ]),
                        ))),
                Container(
                    padding: EdgeInsets.zero,
                    width: double.infinity,
                    height: 45,
                    margin: EdgeInsets.only(
                        top: fullHeight * 0.1,
                        right: fullHeight * 0.1,
                        left: fullHeight * 0.1),
                    child: ElevatedButton(
                      onPressed: () {
                        //Do something
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(roundedLG2),
                        )),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(primaryColor),
                      ),
                      child: const Text('Next'),
                    ))
              ],
            )));
  }
}
