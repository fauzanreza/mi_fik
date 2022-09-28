import 'package:flutter/material.dart';
import 'package:mi_fik/Home/addPost.dart';
import 'package:mi_fik/Home/getContent.dart';
import 'package:mi_fik/Others/custombg.dart';
import 'package:mi_fik/main.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({key});

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
      body: CustomPaint(
          painter: CirclePainter(),
          child: ListView(
              padding: EdgeInsets.only(top: fullHeight * 0.08),
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getGreeting(DateFormat("HH").format(DateTime.now())),
                        const SizedBox(height: 5),
                        Text(DateFormat("HH : mm a").format(DateTime.now()),
                            style: TextStyle(
                                color: whitebg,
                                fontWeight: FontWeight.bold,
                                fontSize: textXL)),
                        SizedBox(height: fullHeight * 0.05),
                        Text(DateFormat("dd MMM yyyy").format(DateTime.now()),
                            style: TextStyle(color: whitebg, fontSize: textMD)),
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
