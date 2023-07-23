import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Dialogs/sign_out_dialog.dart';
import 'package:mi_fik/Components/Skeletons/drawer.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeftBar extends StatelessWidget {
  const LeftBar({Key key}) : super(key: key);

  Future<UserProfileLeftBar> getMiniProfile() async {
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
        future: getMiniProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String username = snapshot.data.username;
            String image = snapshot.data.image;
            String role = snapshot.data.roleGeneral;

            return Drawer(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, semidarkColor],
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
                                  padding: EdgeInsets.all(spaceLG),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        getProfileImageSideBar(
                                            fullWidth, 0.15, image),
                                        Text("@$username",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textXMD + 2,
                                                fontWeight: FontWeight.w500)),
                                        Text("$role ",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textXMD + 2,
                                                fontWeight: FontWeight.w500))
                                      ]),
                                ),
                                getSideBarTile(
                                    fullWidth, Icons.person, "Profile".tr, () {
                                  Get.toNamed(CollectionRoute.profile);
                                }),
                                getSideBarTile(fullWidth, Icons.tag, "Role",
                                    () {
                                  selectedRole.clear();
                                  Get.toNamed(CollectionRoute.role);
                                }),
                                getSideBarTile(fullWidth,
                                    Icons.question_answer_outlined, "FAQ", () {
                                  Get.toNamed(CollectionRoute.faq);
                                }),
                                getSideBarTile(
                                    fullWidth, Icons.help_center, "Help".tr,
                                    () {
                                  Get.toNamed(CollectionRoute.help);
                                })
                              ]),
                        ),
                        getSideBarTile(fullWidth, Icons.settings, "Setting".tr,
                            () {
                          Get.toNamed(CollectionRoute.setting);
                        }),
                        Container(
                          width: fullWidth,
                          margin: EdgeInsets.only(
                              bottom: spaceSM * 2,
                              left: spaceSM,
                              right: spaceSM),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(roundedSM),
                              ),
                              color: warningBG),
                          child: TextButton.icon(
                            onPressed: () {
                              Get.dialog(const SignOutDialog());
                            },
                            icon: Icon(Icons.logout,
                                size: textLG, color: whiteColor),
                            label: Text("Log-Out".tr,
                                style: TextStyle(
                                    color: whiteColor, fontSize: textXMD)),
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
