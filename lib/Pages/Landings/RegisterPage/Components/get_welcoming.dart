import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetWelcoming extends StatefulWidget {
  const GetWelcoming({Key key}) : super(key: key);

  @override
  StateGetWelcoming createState() => StateGetWelcoming();
}

class StateGetWelcoming extends State<GetWelcoming> {
  @override
  Widget build(BuildContext context) {
    // double fullHeight = MediaQuery.of(context).size.height;
    // double fullWidth = MediaQuery.of(context).size.height;

    return ListView(
      padding:
          EdgeInsets.fromLTRB(spaceLG, spaceJumbo + spaceMD, spaceLG, spaceLG),
      children: [
        getTitleLarge("Welcoming".tr, primaryColor),
        Text("MI-FIK Apps".tr,
            style: TextStyle(fontSize: textLG, fontWeight: FontWeight.bold)),
        SizedBox(height: spaceLG),
        Text(
            "Welcome to the Faculty of Creative Industries Information Management Application (MI-FIK), an innovative solution to improve the efficiency and accessibility of information for the entire community at the Faculty of Creative Industries Telkom University."
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        SizedBox(height: spaceLG),
        Text(
            "Telkom University's Faculty of Creative Industries (FIK) has six leading and most comprehensive study programs in the creative field, namely, Bachelor of Visual Communication Design (S.Ds), Bachelor of Interior Design (S.Ds), Bachelor of Product Design (S.Ds), Bachelor of Crafts (S.Sn) and Bachelor of Fine Arts (S.Sn). In 2020, the Faculty of Creative Industries presented one new study program, the Master of Design (M.Ds) program. "
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
        SizedBox(height: spaceLG),
        Text("MI-FIK can be use by :".tr,
            style: TextStyle(fontSize: textXMD, fontWeight: FontWeight.bold)),
        Text("- Faculty Staff".tr, style: TextStyle(fontSize: textXMD - 2)),
        Text("- Lecturer".tr, style: TextStyle(fontSize: textXMD - 2)),
        Text("- Student".tr, style: TextStyle(fontSize: textXMD - 2)),
        SizedBox(height: spaceLG),
        Text(
            "MI-FIK is specifically designed to meet the needs of communication problems in the FIK community in managing and sharing information effectively. With advanced features and an intuitive interface, this application will be a helpful tool for lecturers, staff, and students in disseminating information."
                .tr,
            style: TextStyle(fontSize: textXMD - 2)),
      ],
    );
  }
}
