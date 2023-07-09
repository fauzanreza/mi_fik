import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key key}) : super(key: key);

  @override
  StateIntroPage createState() => StateIntroPage();
}

class StateIntroPage extends State<IntroPage> {
  final selectedRole = [];

  int _index = 0;

  final role = [
    {"id": 0, "role_name": "Lecturer"},
    {"id": 1, "role_name": "Staff"},
    {"id": 2, "role_name": "Student"},
    {"id": 3, "role_name": "Unit"}
  ];

  final studyProg = [
    {"id": 0, "prog_name": "DKV"},
    {"id": 1, "prog_name": "KTM"},
    {"id": 2, "prog_name": "SR"},
    {"id": 3, "prog_name": "DP"},
    {"id": 4, "prog_name": "DI"}
  ];

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: CustomPaint(
            painter: CirclePainterSideWhite(),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: fullHeight * 0.12),
              children: [
                Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Theme(
                          data: ThemeData(
                            canvasColor: hoverBG,
                          ),
                          child: Stepper(
                              controlsBuilder: (context, onStepContinue) {
                                return Container(
                                    margin: const EdgeInsets.only(top: 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_index <= 2) {
                                              setState(() {
                                                _index += 1;
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
                                                EdgeInsets.symmetric(
                                                    vertical: spaceSM,
                                                    horizontal: spaceLG * 2.4)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      roundedMD),
                                            )),
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    primaryColor),
                                          ),
                                          child: Text('Next',
                                              style:
                                                  TextStyle(fontSize: textXMD)),
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
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: fullWidth * 0.15),
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(roundedMD)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 128, 128, 128)
                                                  .withOpacity(0.25),
                                              blurRadius: 10.0,
                                              spreadRadius: 0.0,
                                              offset: const Offset(
                                                3.0,
                                                3.0,
                                              ),
                                            )
                                          ],
                                        ),
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
                                              fontSize: textXMD,
                                              fontWeight: FontWeight.w500)),
                                      Text("Every Information in one app",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textXMD,
                                              fontWeight: FontWeight.w500)),
                                    ])),
                                Step(
                                    title: Text('',
                                        style: TextStyle(color: primaryColor)),
                                    content: Column(children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: fullWidth * 0.15),
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(roundedMD)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 128, 128, 128)
                                                  .withOpacity(0.25),
                                              blurRadius: 10.0,
                                              spreadRadius: 0.0,
                                              offset: const Offset(
                                                3.0,
                                                3.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                          child: Image.asset(
                                              'assets/icon/welcome_2.png',
                                              width: fullHeight * 0.3),
                                        ),
                                      ),
                                      Text("Manage your Task",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textXMD,
                                              fontWeight: FontWeight.w500)),
                                      Text("and Activity",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textXMD,
                                              fontWeight: FontWeight.w500)),
                                    ])),
                                Step(
                                    title: Text('',
                                        style: TextStyle(color: primaryColor)),
                                    content: Column(children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: fullWidth * 0.15),
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(roundedMD)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 128, 128, 128)
                                                  .withOpacity(0.25),
                                              blurRadius: 10.0,
                                              spreadRadius: 0.0,
                                              offset: const Offset(
                                                3.0,
                                                3.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                          child: Image.asset(
                                              'assets/icon/welcome_3.png',
                                              width: fullHeight * 0.2),
                                        ),
                                      ),
                                      Text("Please tell us who You are".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textXMD,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: Wrap(
                                              runSpacing: -5,
                                              spacing: 5,
                                              children: role.map<Widget>(
                                                (rl) {
                                                  getRole(slct) {
                                                    if (slct) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          //Remove selected role
                                                          setState(() {
                                                            selectedRole.removeWhere(
                                                                (item) =>
                                                                    item[
                                                                        'id'] ==
                                                                    rl['id']);
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        roundedMD),
                                                          )),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll<
                                                                      Color>(
                                                                  primaryColor),
                                                        ),
                                                        child: Text(
                                                            rl['role_name'],
                                                            style: TextStyle(
                                                                color:
                                                                    whiteColor)),
                                                      );
                                                    } else {
                                                      return OutlinedButton(
                                                        onPressed: () {
                                                          //Store selected role
                                                          if (selectedRole
                                                              .isEmpty) {
                                                            setState(() {
                                                              selectedRole.add({
                                                                "id": rl['id'],
                                                                "role_name": rl[
                                                                    'role_name']
                                                              });
                                                            });
                                                          } else {
                                                            setState(() {
                                                              selectedRole
                                                                  .clear();
                                                              selectedRole.add({
                                                                "id": rl['id'],
                                                                "role_name": rl[
                                                                    'role_name']
                                                              });
                                                            });
                                                          }
                                                        },
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
                                                                        roundedMD),
                                                          )),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll<
                                                                      Color>(
                                                                  hoverBG),
                                                        ),
                                                        child: Text(
                                                            rl['role_name'],
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColor)),
                                                      );
                                                    }
                                                  }

                                                  if (selectedRole.isNotEmpty) {
                                                    if (rl['role_name'] ==
                                                        selectedRole[0]
                                                            ['role_name']) {
                                                      return getRole(true);
                                                    } else {
                                                      return getRole(false);
                                                    }
                                                  } else {
                                                    return getRole(false);
                                                  }
                                                },
                                              ).toList()))
                                    ])),
                                Step(
                                    title: Text('',
                                        style: TextStyle(color: primaryColor)),
                                    content: Column(children: [
                                      Text("Choose your role",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: textXMD,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Text(
                                            "Role system will shows your preferable information in your timeline, and you can save your information based on your roles to archive. Please choose your roles based on your academic situation right now.",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: textXMD,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: TextFormField(
                                          cursorColor: whiteColor,
                                          decoration: InputDecoration(
                                            hintText: 'Search',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryColor),
                                            ),
                                            prefixIcon: Icon(Icons.search,
                                                color: primaryColor),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: Wrap(
                                              runSpacing: -5,
                                              spacing: 5,
                                              children: studyProg.map<Widget>(
                                                (sp) {
                                                  return OutlinedButton(
                                                    onPressed: () {},
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
                                                                    roundedMD),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                              Color>(hoverBG),
                                                    ),
                                                    child: Text(sp['prog_name'],
                                                        style: TextStyle(
                                                            color:
                                                                primaryColor)),
                                                  );
                                                },
                                              ).toList()))
                                    ]))
                              ]),
                        ))),
              ],
            )));
  }
}
