import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Charts/show_calendar.dart';
import 'package:mi_fik/Components/Container/attendance.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key key}) : super(key: key);

  @override
  StateAttendancePage createState() => StateAttendancePage();
}

class StateAttendancePage extends State<AttendancePage> {
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

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Attendance".tr, () {
        Get.back();
      }),
      body: ListView(
        children: [
          ShowCalendar(
            active: selectedDay,
            format: format,
            setActionday: updateDay,
            setActionformat: updateFormat,
          ),
          GetAttendanceContainer(width: fullWidth, servc: null, content: null)
        ],
      ),
    );
  }
}
