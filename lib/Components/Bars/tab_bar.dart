import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Tabs/archive_tab.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Tabs/my_schedule_tab.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Tabs/saved_content_tab.dart';

// Tab Collection
getArchiveView(slctd) {
  if (slctd == null) {
    return {"title": "Archive", "class": const ArchievePage()};
  } else {
    return {"title": slctd.toString(), "class": const SavedContent()};
  }
}

var tabColSchedule = [
  {"title": "My Schedule", "class": const MySchedulePage()},
  getArchiveView(selectedArchiveName)
];

class GetTabBar extends StatelessWidget {
  final double width;
  final double height;
  var col;
  final TabController ctrl;

  GetTabBar({Key key, this.width, this.height, this.ctrl, this.col})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: TabBar(
            controller: ctrl,
            labelColor: greybg,
            indicatorColor: primaryColor,
            labelStyle:
                TextStyle(fontSize: textMD, fontWeight: FontWeight.w500),
            indicatorPadding: EdgeInsets.symmetric(horizontal: width * 0.1),
            tabs: List.generate(col.length, (index) {
              return Tab(text: col[index]['title']);
            })),
      ),
      SizedBox(
        height: height * 0.7,
        child: TabBarView(
          controller: ctrl,
          children: List.generate(col.length, (index) {
            return col[index]['class'];
          }),
        ),
      )
    ]);
  }
}
