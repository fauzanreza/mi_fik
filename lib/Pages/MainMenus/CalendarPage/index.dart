import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_fik/Components/Bars/Usecases/show_side_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/Usecases/show_calendar.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/Usecases/show_daily_header.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = slctCalendar;
  DateTime focusedDay = slctCalendar;

  void updateDay(DateTime newSelectDay, DateTime newFocusDay) {
    setState(
      () {
        selectedDay = newSelectDay;
        focusedDay = newFocusDay;
        slctCalendar = newSelectDay;
        selectedIndex = 2;
      },
    );
  }

  void updateFormat(CalendarFormat newFormat) {
    setState(
      () {
        format = newFormat;
      },
    );
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
          key: scaffoldKey,
          drawer: const LeftBar(),
          drawerScrimColor: primaryColor.withOpacity(0.35),
          endDrawer: const RightBar(),
          body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: refreshData,
              child: ListView(
                padding: EdgeInsets.only(top: fullHeight * 0.04),
                children: [
                  showSideBar(scaffoldKey, primaryColor),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShowCalendar(
                        active: selectedDay,
                        format: format,
                        setActionday: updateDay,
                        setActionformat: updateFormat,
                      ),
                      DayHeader(selectedDay: selectedDay),
                    ],
                  ),
                ],
              ))),
    );
  }
}
