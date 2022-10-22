import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Schedule/Archieve.dart';
import 'package:mi_fik/Schedule/MySchedule.dart';
import 'package:mi_fik/main.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePage createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

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
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: textXL));
    }

    return Scaffold(
        body: ListView(
            padding: EdgeInsets.only(top: fullHeight * 0.05),
            children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Text(DateFormat("dd MMM yyyy").format(DateTime.now()),
                  style: TextStyle(
                      color: blackbg,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(DateFormat("HH : mm a").format(DateTime.now()),
                  style: TextStyle(
                      color: blackbg,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: getGreeting(DateFormat("HH").format(DateTime.now())),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            height: 56,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  //Get day style.
                  getBgcolor(i) {
                    if (i == 0) {
                      return primaryColor;
                    } else {
                      return whitebg;
                    }
                  }

                  getcolor(i) {
                    if (i == 0) {
                      return whitebg;
                    } else {
                      return blackbg;
                    }
                  }

                  return GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            slctSchedule =
                                slctSchedule.add(Duration(days: index));
                          },
                        );
                      },
                      child: Container(
                        width: 56,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: getBgcolor(index),
                          borderRadius: BorderRadius.all(roundedMd),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 128, 128, 128)
                                  .withOpacity(0.3),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                            )
                          ],
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  DateFormat("EEE").format(
                                      slctSchedule.add(Duration(days: index))),
                                  style: TextStyle(
                                      color: getcolor(index),
                                      fontSize: textSM,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  (slctSchedule.add(Duration(days: index)).day)
                                      .toString(),
                                  style: TextStyle(
                                      color: getcolor(index),
                                      fontSize: textXLG,
                                      fontWeight: FontWeight.w500))
                            ]),
                      ));
                }),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: TabBar(
              controller: _tabController,
              labelColor: greybg,
              indicatorColor: primaryColor,
              labelStyle:
                  TextStyle(fontSize: textMD, fontWeight: FontWeight.w500),
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: fullWidth * 0.1),
              tabs: const <Widget>[
                Tab(
                  text: "My Schedule",
                ),
                Tab(
                  text: "Archieve",
                ),
              ],
            ),
          ),
          Container(
            height: fullHeight * 0.7,
            child: TabBarView(
              controller: _tabController,
              children: [MySchedulePage(), ArchievePage()],
            ),
          )
        ]));
  }
}
