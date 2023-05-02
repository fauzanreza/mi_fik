import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/edit_profile.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/show_profile.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/show_roles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: getAppbar("Profile"),
        body: CustomPaint(
            painter: CirclePainter(),
            child: ListView(
                padding: EdgeInsets.only(top: fullHeight * 0.04),
                children: [
                  ShowProfile(),
                  const GetEditProfile(),
                  Container(
                      height: fullHeight * 0.7,
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.only(
                          top: paddingMD, left: paddingSM, right: paddingSM),
                      decoration: BoxDecoration(
                        color: mainbg,
                        borderRadius: BorderRadius.only(
                            topLeft: roundedLG, topRight: roundedLG),
                      ),
                      child: Column(
                        children: [
                          const ShowRole(),
                          getSignOutButtonWide(context)
                        ],
                      )),
                ])));
  }
}
