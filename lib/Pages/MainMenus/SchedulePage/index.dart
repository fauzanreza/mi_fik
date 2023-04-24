import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/Usecases/show_side_bar.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Components/Bars/tab_bar.dart';
import 'package:mi_fik/Components/Typography/show_greeting.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/add_task.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_weekly.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePage createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void navigateDay(int newValue) {
    setState(() {
      slctSchedule = slctSchedule.add(Duration(days: newValue));
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BottomBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    getOpenedArchive(slctd) {
      if (slctd == null) {
        return "Archive";
      } else {
        return slctd.toString();
      }
    }

    return Scaffold(
        key: scaffoldKey,
        drawer: const LeftBar(),
        drawerScrimColor: primaryColor.withOpacity(0.35),
        endDrawer: const RightBar(),
        body: ListView(
            padding: EdgeInsets.only(top: fullHeight * 0.04), //Check this!!!
            children: [
              showSideBar(scaffoldKey, primaryColor),
              Container(
                padding: const EdgeInsets.all(10),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  getGreeting(getToday("part"), primaryColor),
                  const Spacer(),
                  getSubTitleMedium(getToday("date"), blackbg)
                ]),
              ),
              GetWeeklyNavigator(active: slctSchedule, action: navigateDay),
              GetTabBar(
                  width: fullWidth,
                  height: fullHeight,
                  ctrl: tabController,
                  col: tabColSchedule)
            ]),
        floatingActionButton: AddTaskwArchive());
  }
}
