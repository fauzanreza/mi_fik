import 'package:flutter/material.dart';
import 'package:mi_fik/AddPost/index.dart';
import 'package:mi_fik/Home/getContent.dart';
import 'package:mi_fik/Others/custombg.dart';
import 'package:mi_fik/Others/leftbar.dart';
import 'package:mi_fik/Others/rightbar.dart';
import 'package:mi_fik/main.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    //Get greeting in header
    Widget getGreeting(hours) {
      var hour = int.parse(hours);
      var greet = "";
      if (hour >= 0 && hour <= 12) {
        greet = "Good Morning";
      } else if (hour > 12 && hour <= 17) {
        greet = "Good Evening";
      } else if (hour > 17 && hour <= 24) {
        greet = "Good Night";
      }
      return Text(greet,
          style: TextStyle(
              color: whitebg, fontWeight: FontWeight.w500, fontSize: textLG));
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: const LeftBar(),
      drawerScrimColor: primaryColor.withOpacity(0.35),
      endDrawer: RightBar(),
      body: CustomPaint(
          painter: CirclePainter(),
          child: ListView(
              padding: EdgeInsets.only(top: fullHeight * 0.04),
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  child: Row(children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.menu, size: 32, color: whitebg),
                      tooltip: '...',
                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.notifications, size: 32, color: whitebg),
                      tooltip: 'Notification',
                      onPressed: () =>
                          _scaffoldKey.currentState.openEndDrawer(),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getGreeting(DateFormat("HH").format(DateTime.now())),
                        const SizedBox(height: 5),
                        Text(DateFormat("hh : mm a").format(DateTime.now()),
                            style: TextStyle(
                                color: whitebg,
                                fontWeight: FontWeight.bold,
                                fontSize: textXL)),
                        SizedBox(height: fullHeight * 0.05),
                        Row(
                          children: [
                            Text(
                                DateFormat("dd MMM yyyy")
                                    .format(DateTime.now()),
                                style: TextStyle(
                                    color: whitebg, fontSize: textMD)),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                      color: whitebg,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " :",
                                    style: TextStyle(color: whitebg),
                                  ),
                                ],
                              ),
                            )
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
                    child: IntrinsicHeight(
                      child: Column(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(10),
                          child: Text("What's New ?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: textLG,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const Flexible(child: GetContent())
                      ]),
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
