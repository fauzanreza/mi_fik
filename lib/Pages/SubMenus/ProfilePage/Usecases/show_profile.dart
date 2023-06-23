import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/edit_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProfile extends StatelessWidget {
  const ShowProfile({Key key}) : super(key: key);

  Future<UserProfileLeftBar> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username_key');
    final image = prefs.getString('image_key');
    final role = prefs.getString('role_general_key');

    if (role != null && image != null && username != null) {
      return UserProfileLeftBar(
          username: username, image: image, roleGeneral: role);
    } else {
      Get.offAll(() => const LoginPage());
      Get.snackbar("Alert".tr, "Session lost, please sign in again".tr,
          backgroundColor: whitebg);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<UserProfileLeftBar>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            String username = snapshot.data.username;
            String image = snapshot.data.image;
            String role = snapshot.data.roleGeneral;

            return Container(
              width: fullWidth,
              padding:
                  EdgeInsets.fromLTRB(paddingXSM, paddingXSM, paddingXSM, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      Container(
                          margin: const EdgeInsets.all(20),
                          child: getProfileImageSideBar(fullWidth, 0.3, image)),
                      const EditImage(),
                    ]),
                    Text(username,
                        style: TextStyle(
                            color: whitebg,
                            fontSize: textLG,
                            fontWeight: FontWeight.w500)),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 5, left: 5, right: 5),
                        padding: EdgeInsets.symmetric(
                            vertical: paddingXSM / 2, horizontal: paddingSM),
                        decoration: BoxDecoration(
                            color: whitebg,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(role,
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: textMD,
                                fontWeight: FontWeight.w500)))
                  ]),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
