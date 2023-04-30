import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Bars/Usecases/show_side_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/get_content.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/get_location.dart';
import 'package:mi_fik/Components/Typography/show_greeting.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/post_task.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/index.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Role> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role_general_key');
    return Role(role: role);
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<Role>(
        future: getToken(),
        builder: (context, snapshot) {
          getRoleFeature(String role) {
            if (role != "Student") {
              return SpeedDial(
                  activeIcon: Icons.close,
                  icon: Icons.add,
                  backgroundColor: primaryColor,
                  overlayColor: primaryColor,
                  overlayOpacity: 0.4,
                  children: [
                    getSpeeDialChild("New Task", context, PostTask(),
                        Icons.note_add_outlined),
                    getSpeeDialChild("New Post", context, AddPost(),
                        Icons.post_add_outlined),
                  ],
                  child: Icon(Icons.add, size: iconLG));
            } else {
              return SpeedDial(
                  activeIcon: Icons.close,
                  icon: Icons.add,
                  backgroundColor: primaryColor,
                  overlayColor: primaryColor,
                  overlayOpacity: 0.4,
                  children: [
                    getSpeeDialChild("New Task", context, PostTask(),
                        Icons.note_add_outlined),
                  ],
                  child: Icon(Icons.add, size: iconLG));
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            String role = snapshot.data.role;

            return Scaffold(
              key: scaffoldKey,
              drawer: const LeftBar(),
              drawerScrimColor: primaryColor.withOpacity(0.35),
              endDrawer: const RightBar(),
              body: CustomPaint(
                  painter: CirclePainter(),
                  child: ListView(
                      padding: EdgeInsets.only(top: fullHeight * 0.04),
                      children: [
                        showSideBar(scaffoldKey, whitebg),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getGreeting(getToday("part"), whitebg),
                                getTitleJumbo(getToday("clock"), whitebg),
                                SizedBox(height: fullHeight * 0.05),
                                Row(
                                  children: [
                                    getSubTitleMedium(
                                        getToday("date"), whitebg),
                                    const Spacer(),
                                    LocationTitle()
                                  ],
                                )
                              ]),
                        ),
                        Container(
                            //height: double.infinity,
                            margin: const EdgeInsets.only(top: 10.0),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: mainbg,
                              borderRadius: BorderRadius.only(
                                  topLeft: roundedLG, topRight: roundedLG),
                            ),
                            child: const IntrinsicHeight(
                              child: Flexible(child: GetContent()),
                            ))
                      ])),
              floatingActionButton: getRoleFeature(role),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
