import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Dialogs/sign_out_dialog.dart';
import 'package:mi_fik/Components/Skeletons/drawer.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/HelpPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';
import 'package:mi_fik/Pages/SubMenus/SettingPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeftBar extends StatelessWidget {
  const LeftBar({Key key}) : super(key: key);

  Future<UserProfileLeftBar> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username_key');
    final image = prefs.getString('image_key');
    final role = prefs.getString('role_general_key');
    return UserProfileLeftBar(
        username: username, image: image, roleGeneral: role);
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<UserProfileLeftBar>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String username = snapshot.data.username;
            String image = snapshot.data.image;
            String role = snapshot.data.roleGeneral;

            return Drawer(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, semiblackbg],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: fullHeight * 0.75,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: fullWidth,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        getProfileImageSideBar(
                                            fullWidth, 0.15, image),
                                        Text(username,
                                            style: TextStyle(
                                                color: whitebg,
                                                fontSize: textMD,
                                                fontWeight: FontWeight.w500)),
                                        Text(role,
                                            style: TextStyle(
                                                color: whitebg,
                                                fontSize: textMD,
                                                fontWeight: FontWeight.w500))
                                      ]),
                                ),
                                getSideBarTile(
                                    fullWidth, Icons.person, "Profile".tr, () {
                                  Get.to(() => const ProfilePage());
                                }),
                                getSideBarTile(fullWidth, Icons.tag, "Role",
                                    () {
                                  selectedRole.clear();
                                  Get.to(() => const RolePage());
                                }),
                                getSideBarTile(fullWidth,
                                    Icons.question_answer_outlined, "FAQ", () {
                                  Get.to(() => const FAQPage());
                                }),
                                getSideBarTile(
                                    fullWidth, Icons.help_center, "Help".tr,
                                    () {
                                  Get.to(() => const HelpPage());
                                }),
                              ]),
                        ),
                        getSideBarTile(fullWidth, Icons.settings, "Setting".tr,
                            () {
                          Get.to(() => const SettingPage());
                        }),
                        Container(
                          width: fullWidth,
                          margin: EdgeInsets.only(
                              bottom: paddingXSM * 2,
                              left: paddingXSM,
                              right: paddingXSM),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(roundedMd2),
                              ),
                              color: dangerColor),
                          child: TextButton.icon(
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const SignOutDialog());
                            },
                            icon: Icon(Icons.logout,
                                size: textXLG, color: whitebg),
                            label: Text("Log-Out".tr,
                                style: TextStyle(
                                    color: whitebg, fontSize: textMD)),
                            style: ElevatedButton.styleFrom(),
                          ),
                        )
                      ],
                    )));
          } else {
            return const DrawerSkeleton();
          }
        });
  }
}
