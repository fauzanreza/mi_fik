import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetWelcoming extends StatefulWidget {
  const GetWelcoming({Key key}) : super(key: key);

  @override
  StateGetWelcoming createState() => StateGetWelcoming();
}

class StateGetWelcoming extends State<GetWelcoming> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        contentPadding: const EdgeInsets.all(10),
                        title: Text('Warning'.tr),
                        content: SizedBox(
                          width: fullWidth,
                          height: 50,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                        "Are you sure want to close the registration?"
                                            .tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: shadowColor,
                                            fontSize: textMD)))
                              ]),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(roundedSM),
                              )),
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(warningBG),
                            ),
                            onPressed: () async {
                              indexRegis = 0;
                              usernameAvaiabilityCheck = "";
                              emailAvaiabilityCheck = "";
                              passRegisCtrl = "";
                              fnameRegisCtrl = "";
                              lnameRegisCtrl = "";
                              validRegisCtrl = 2023;
                              isCheckedRegister = false;
                              isFillForm = false;
                              isChooseRole = false;
                              checkAvaiabilityRegis = false;
                              isFinishedRegis = false;
                              uploadedImageRegis = null;
                              isWaiting = false;
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();

                              Get.offAll(() => const LoginPage());
                            },
                            child: Text("Yes".tr,
                                style: TextStyle(color: whiteColor)),
                          )
                        ],
                      )),
              child: Container(
                margin: EdgeInsets.only(
                    left: spaceLG, right: spaceLG, top: spaceJumbo),
                padding: EdgeInsets.all(spaceXMD - 2),
                width: 180,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: warningBG, size: iconLG),
                    SizedBox(width: spaceXMD),
                    Text("Back to Sign In",
                        style: TextStyle(
                            color: warningBG,
                            fontSize: textMD,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(spaceLG),
          margin: EdgeInsets.all(spaceLG),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.35),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
              )
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            getTitleLarge("Welcoming", primaryColor),
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet risus nullam eget felis. Nibh tellus molestie nunc non blandit massa enim. Dolor magna eget est lorem ipsum dolor sit amet. Maecenas ultricies mi eget mauris pharetra et ultrices. Purus sit amet volutpat consequat mauris nunc congue. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Mi ipsum faucibus vitae aliquet. Viverra justo nec ultrices dui sapien eget mi proin sed. Enim nulla aliquet porttitor lacus.",
                style: TextStyle(fontSize: textMD - 2)),
            SizedBox(height: spaceLG),
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet risus nullam eget felis. Nibh tellus molestie nunc non blandit massa enim. Dolor magna eget est lorem ipsum dolor sit amet. Maecenas ultricies mi eget mauris pharetra et ultrices. Purus sit amet volutpat consequat mauris nunc congue. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Mi ipsum faucibus vitae aliquet. Viverra justo nec ultrices dui sapien eget mi proin sed. Enim nulla aliquet porttitor lacus.",
                style: TextStyle(fontSize: textMD - 2)),
          ]),
        )
      ],
    );
  }
}
