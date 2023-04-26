import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProfile extends StatelessWidget {
  Future<UserProfileLeftBar> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username_key');
    final image = prefs.getString('image_key');
    return UserProfileLeftBar(username: username, image: image);
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

            return Container(
              width: fullWidth,
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getProfileImageSideBar(fullWidth, 0.3, image),
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
                        child: Text(passRoleGeneral,
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
