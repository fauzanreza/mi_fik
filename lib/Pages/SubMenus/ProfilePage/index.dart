import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/show_profile.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Usecases/show_roles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Future<UserProfileLeftBar> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username_key');
    final image = prefs.getString('image_key');
    final roles = jsonDecode(prefs.getString('role_lsit_key'));
    return UserProfileLeftBar(username: username, image: image, roles: roles);
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
            List<dynamic> roles = snapshot.data.roles;
            return Scaffold(
                appBar: getAppbar("Profile"),
                body: CustomPaint(
                    painter: CirclePainter(),
                    child: ListView(
                        padding: EdgeInsets.only(top: fullHeight * 0.04),
                        children: [
                          ShowProfile(username: username, image: image),
                          Container(
                              height: fullHeight,
                              margin: const EdgeInsets.only(top: 10.0),
                              padding: EdgeInsets.only(
                                  top: paddingMD,
                                  left: paddingSM,
                                  right: paddingSM),
                              decoration: BoxDecoration(
                                color: mainbg,
                                borderRadius: BorderRadius.only(
                                    topLeft: roundedLG, topRight: roundedLG),
                              ),
                              child: Column(
                                children: [ShowRole(tags: roles)],
                              )),
                        ])));
          } else {
            return SizedBox();
          }
        });
  }
}
