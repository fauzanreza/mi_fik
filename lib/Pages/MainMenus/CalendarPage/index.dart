import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/Usecases/show_side_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/Usecases/show_calendar.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/Usecases/show_daily_header.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key key}) : super(key: key);

  @override
  StateCalendarPageState createState() => StateCalendarPageState();
}

class StateCalendarPageState extends State<CalendarPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ScrollController scrollCtrl;

  ContentQueriesService queryService;
  ContentCommandsService commandService;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = slctCalendar;
  DateTime focusedDay = slctCalendar;
  int page = 1;
  int totalPage = 1;
  List<ScheduleModel> contents = [];
  bool isLoading = false;
  bool isEmpty = false;

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
    page = 1;
    contents.clear();
    loadMoreContent();
  }

  @override
  void initState() {
    super.initState();
    queryService = ContentQueriesService();
    commandService = ContentCommandsService();
    scrollCtrl = ScrollController()
      ..addListener(() {
        if (scrollCtrl.offset == scrollCtrl.position.maxScrollExtent) {
          loadMoreContent();
        }
      });
    loadMoreContent();
  }

  Future<void> loadMoreContent() async {
    if (!isLoading) {
      if (page <= totalPage) {
        setState(() {
          isLoading = true;
        });

        List<ScheduleModel> items =
            await queryService.getSchedule(slctSchedule, page);

        if (items != null) {
          contents.addAll(items);
          for (var element in items) {
            totalPage = element.totalPage;
          }
          page++;
        } else {
          isEmpty = true;
        }

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    //scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        selectedIndex = 0;
        Get.toNamed(CollectionRoute.bar, preventDuplicates: false);
        return null;
      },
      child: Scaffold(
          key: scaffoldKey,
          drawer: const LeftBar(),
          drawerScrimColor: primaryColor.withOpacity(0.35),
          endDrawer: const RightBar(),
          body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: refreshData,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: fullHeight * 0.04),
                  itemCount: 1,
                  controller: scrollCtrl,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        showSideBar(scaffoldKey, primaryColor),
                        ShowCalendar(
                          active: selectedDay,
                          format: format,
                          setActionday: updateDay,
                          setActionformat: updateFormat,
                        ),
                        DayHeader(selectedDay: selectedDay, item: contents),
                      ],
                    );
                  }))),
    );
  }
}
