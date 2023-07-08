import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/HistoryPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/MyFAQPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/edit_profile.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/show_profile.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/show_roles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  StateProfilePage createState() => StateProfilePage();
}

class StateProfilePage extends State<ProfilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> refreshData() async {
    Get.offAll(() => const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;
    String versionText = "Version".tr;

    return Scaffold(
        appBar: getAppbar("Profile".tr, () {
          Get.to(() => const BottomBar());
        }),
        body: CustomPaint(
            painter: CirclePainter(),
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: refreshData,
                child: ListView(
                    padding: EdgeInsets.only(top: fullHeight * 0.04),
                    children: [
                      const ShowProfile(),
                      const GetEditProfile(),
                      Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.fromLTRB(
                              spaceXMD, spaceLG, spaceXMD, spaceJumbo),
                          decoration: BoxDecoration(
                            color: hoverBG,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(roundedLG),
                                topRight: Radius.circular(roundedLG)),
                          ),
                          child: Column(
                            children: [
                              const ShowRole(),
                              getProfileButton(() {
                                Get.to(() => const MyFAQPage());
                              }, Icons.question_answer, "My Question".tr,
                                  Icons.keyboard_arrow_right),
                              getProfileButton(() {
                                Get.to(() => const HistoryPage());
                              }, Icons.history, "History".tr,
                                  Icons.keyboard_arrow_right),
                              getProfileButton(() {
                                Get.to(() => const AboutPage());
                              }, Icons.info, "About Us".tr,
                                  Icons.keyboard_arrow_right),
                              Container(
                                margin: EdgeInsets.only(top: spaceLG * 2),
                                child: Text("$versionText 1.0",
                                    style: TextStyle(fontSize: textSM)),
                              ),
                              getSignOutButtonWide(context)
                            ],
                          )),
                    ]))));
  }
}
