import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/Usecases/show_side_bar.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Modules/Translators/service.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Tabs/archive_tab.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Tabs/my_schedule_tab.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Tabs/saved_content_tab.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/post_archive.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/post_task.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_weekly.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key key}) : super(key: key);

  @override
  StateSchedulePage createState() => StateSchedulePage();
}

class StateSchedulePage extends State<SchedulePage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  LangCtrl langctrl = Get.put(LangCtrl());

  getStartIndex(String slug) {
    if (slug == null) {
      return 0;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: getStartIndex(selectedArchiveSlug));
  }

  void navigateDay(int newValue) {
    setState(() {
      if (selectedArchiveSlug != null) {
        selectedArchiveSlug = null;
        selectedArchiveName = null;
      }
      tabController = TabController(
          length: 2, vsync: this, initialIndex: getStartIndex(null));
      slctSchedule = slctSchedule.add(Duration(days: newValue));
    });
    Get.to(() => const BottomBar());
  }

  getArchiveView(slctd) {
    if (slctd == null) {
      // ignore: prefer_const_constructors
      return {"title": "Archive".tr, "class": ArchivePage()};
    } else {
      return {
        "title": selectedArchiveName,
        "class": SavedContent(
            slug: slctd, name: selectedArchiveName, desc: selectedArchiveDesc)
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    var tabColSchedule = [
      // ignore: prefer_const_constructors
      {"title": "My Schedule".tr, "class": MySchedulePage()},
      getArchiveView(selectedArchiveSlug)
    ];

    return WillPopScope(
        onWillPop: () {
          return SystemNavigator.pop();
        },
        child: Scaffold(
            key: scaffoldKey,
            drawer: const LeftBar(),
            drawerScrimColor: primaryColor.withOpacity(0.35),
            endDrawer: const RightBar(),
            body: ListView(
                padding:
                    EdgeInsets.only(top: fullHeight * 0.04), //Check this!!!
                children: [
                  showSideBar(scaffoldKey, primaryColor),
                  // Container(
                  //   padding: const EdgeInsets.all(10),
                  //   child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       children: [
                  //         getGreeting(getToday("part"), primaryColor),
                  //         const Spacer(),
                  //         getSubTitleMedium(
                  //             getToday("date"), darkColor, TextAlign.start)
                  //       ]),
                  // ),
                  GetWeeklyNavigator(active: slctSchedule, action: navigateDay),
                  TabBar(
                      controller: tabController,
                      labelColor: shadowColor,
                      indicatorColor: primaryColor,
                      labelStyle: TextStyle(
                          fontSize: textMD, fontWeight: FontWeight.w500),
                      indicatorPadding:
                          EdgeInsets.symmetric(horizontal: fullWidth * 0.1),
                      tabs: List.generate(tabColSchedule.length, (index) {
                        return Tab(text: tabColSchedule[index]['title']);
                      })),

                  SizedBox(
                    height: fullHeight * 0.7,
                    child: TabBarView(
                      controller: tabController,
                      children: List.generate(tabColSchedule.length, (index) {
                        return tabColSchedule[index]['class'];
                      }),
                    ),
                  )
                ]),
            floatingActionButton: SpeedDial(
                activeIcon: Icons.close,
                icon: Icons.add,
                iconTheme: IconThemeData(color: whiteColor),
                backgroundColor: primaryColor,
                overlayColor: primaryColor,
                overlayOpacity: 0.4,
                children: [
                  getSpeeDialChild("New Task".tr, context, PostTask(),
                      Icons.note_add_outlined),
                  getSpeeDialChild("New Archive".tr, context,
                      const PostArchive(), Icons.folder)
                ])));
  }
}
