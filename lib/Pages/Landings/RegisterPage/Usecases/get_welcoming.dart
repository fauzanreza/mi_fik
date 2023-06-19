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

    return ListView(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () async {
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
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Get.offAll(() => const LoginPage());
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: paddingMD, right: paddingMD, top: paddingLg),
                padding: EdgeInsets.all(paddingSM - 2),
                width: 180,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: dangerColor, size: iconLG),
                    SizedBox(width: paddingSM),
                    Text("Back to Sign In",
                        style: TextStyle(
                            color: dangerColor,
                            fontSize: textMD,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(paddingMD),
          margin: EdgeInsets.all(paddingMD),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: whitebg,
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
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
            SizedBox(height: paddingMD),
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet nec ullamcorper sit amet risus nullam eget felis. Nibh tellus molestie nunc non blandit massa enim. Dolor magna eget est lorem ipsum dolor sit amet. Maecenas ultricies mi eget mauris pharetra et ultrices. Purus sit amet volutpat consequat mauris nunc congue. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Mi ipsum faucibus vitae aliquet. Viverra justo nec ultrices dui sapien eget mi proin sed. Enim nulla aliquet porttitor lacus.",
                style: TextStyle(fontSize: textMD - 2)),
          ]),
        )
      ],
    );
  }
}
