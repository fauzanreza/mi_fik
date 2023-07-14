import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/Usecases/show_daily_event.dart';

class DayHeader extends StatefulWidget {
  const DayHeader({Key key, this.selectedDay}) : super(key: key);
  final DateTime selectedDay;

  @override
  StateDayHeader createState() => StateDayHeader();
}

class StateDayHeader extends State<DayHeader> with TickerProviderStateMixin {
  ContentQueriesService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ContentQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getTotalSchedule(slctCalendar),
        builder: (BuildContext context,
            AsyncSnapshot<List<ScheduleTotalModel>> snapshot) {
          if (snapshot.hasError) {
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ScheduleTotalModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ScheduleTotalModel> contents) {
    getTotalContext(var item) {
      String ev = "Events";
      String ts = "Tasks";
      String total;

      if (item != null) {
        total =
            '${validateZero(item[0].content)} ${ev.tr} and ${validateZero(item[0].task)} ${ts.tr}';
      } else {
        total = '0 ${ev.tr} and 0 ${ts.tr}';
      }
      return total;
    }

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: spaceXMD),
            child: Column(
              children: [
                Text(
                  DateFormat("EEE").format(widget.selectedDay),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: textLG,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat("d").format(widget.selectedDay),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: textLG,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: spaceXMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTodayCalendarHeader(widget.selectedDay),
                  style: TextStyle(
                    color: shadowColor,
                    fontSize: textXLG,
                  ),
                ),
                Text(
                  getTotalContext(contents),
                  style: TextStyle(
                    color: shadowColor,
                    fontSize: textXMD,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const DayEvent()
    ]);
  }
}
