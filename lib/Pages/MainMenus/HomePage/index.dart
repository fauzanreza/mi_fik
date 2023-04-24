import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Bars/Usecases/show_side_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/get_content.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/get_location.dart';
import 'package:mi_fik/Components/Typography/show_greeting.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/index.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

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
                            getSubTitleMedium(getToday("date"), whitebg),
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
      floatingActionButton: SpeedDial(
          activeIcon: Icons.close,
          icon: Icons.add,
          backgroundColor: primaryColor,
          overlayColor: primaryColor,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.post_add_outlined),
              label: 'New Task',
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              onTap: () {},
            ),
            SpeedDialChild(
              child: const Icon(Icons.note_add_outlined),
              label: 'New Post',
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const addPost()),
                );
              },
            ),
          ],
          child: Icon(Icons.add, size: iconLG)),
    );
  }
}
