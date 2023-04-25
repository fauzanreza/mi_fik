import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Skeletons/drawer.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeftBar extends StatelessWidget {
  const LeftBar({Key key}) : super(key: key);

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
                          height: fullHeight * 0.7,
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
                                            fullWidth, image),
                                        Text(username,
                                            style: TextStyle(
                                                color: whitebg,
                                                fontSize: textMD,
                                                fontWeight: FontWeight.w500)),
                                        Text("Dosen FIK",
                                            style: TextStyle(
                                                color: whitebg,
                                                fontSize: textMD,
                                                fontWeight: FontWeight.w500))
                                      ]),
                                ),
                                Container(
                                  width: fullWidth,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: paddingXSM),
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(Icons.person,
                                        size: textXLG, color: whitebg),
                                    label: Text("Profile",
                                        style: TextStyle(
                                            color: whitebg, fontSize: textMD)),
                                    style: ElevatedButton.styleFrom(),
                                  ),
                                ),
                                Container(
                                  width: fullWidth,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: paddingXSM),
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(Icons.folder_open,
                                        size: textXLG, color: whitebg),
                                    label: Text("Archive",
                                        style: TextStyle(
                                            color: whitebg, fontSize: textMD)),
                                    style: ElevatedButton.styleFrom(),
                                  ),
                                ),
                                Container(
                                  width: fullWidth,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: paddingXSM),
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(
                                        Icons
                                            .tag, //Change w/ asset icon from figma
                                        size: textXLG,
                                        color: whitebg),
                                    label: Text("Role",
                                        style: TextStyle(
                                            color: whitebg, fontSize: textMD)),
                                    style: ElevatedButton.styleFrom(),
                                  ),
                                ),
                                Container(
                                  width: fullWidth,
                                  margin: EdgeInsets.only(
                                      left: paddingXSM, right: paddingXSM),
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(Icons.checklist,
                                        size: textXLG, color: whitebg),
                                    label: Text("Schedule",
                                        style: TextStyle(
                                            color: whitebg, fontSize: textMD)),
                                    style: ElevatedButton.styleFrom(),
                                  ),
                                ),
                                Container(
                                  width: fullWidth,
                                  margin: EdgeInsets.only(
                                      left: paddingXSM, right: paddingXSM),
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(Icons.question_answer_outlined,
                                        size: textXLG, color: whitebg),
                                    label: Text("FAQ",
                                        style: TextStyle(
                                            color: whitebg, fontSize: textMD)),
                                    style: ElevatedButton.styleFrom(),
                                  ),
                                ),
                                Container(
                                  width: fullWidth,
                                  margin: EdgeInsets.only(
                                      left: paddingXSM, right: paddingXSM),
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(Icons.help_center,
                                        size: textXLG, color: whitebg),
                                    label: Text("Help",
                                        style: TextStyle(
                                            color: whitebg, fontSize: textMD)),
                                    style: ElevatedButton.styleFrom(),
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          width: fullWidth,
                          margin: EdgeInsets.symmetric(horizontal: paddingXSM),
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () async {},
                            icon:
                                Icon(Icons.info, size: textXLG, color: whitebg),
                            label: Text("About",
                                style: TextStyle(
                                    color: whitebg, fontSize: textMD)),
                            style: ElevatedButton.styleFrom(),
                          ),
                        ),
                        Container(
                          width: fullWidth,
                          margin: EdgeInsets.symmetric(horizontal: paddingXSM),
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () async {},
                            icon: Icon(Icons.settings,
                                size: textXLG, color: whitebg),
                            label: Text("Setting",
                                style: TextStyle(
                                    color: whitebg, fontSize: textMD)),
                            style: ElevatedButton.styleFrom(),
                          ),
                        ),
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
                            onPressed: () async {},
                            icon: Icon(Icons.logout,
                                size: textXLG, color: whitebg),
                            label: Text("Log Out",
                                style: TextStyle(
                                    color: whitebg, fontSize: textMD)),
                            style: ElevatedButton.styleFrom(),
                          ),
                        )
                      ],
                    )));
          } else {
            return DrawerSkeleton();
          }
        });
  }
}
