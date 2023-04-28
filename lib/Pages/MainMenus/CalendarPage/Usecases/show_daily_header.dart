import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class DayHeader extends StatefulWidget {
  DayHeader({Key key, this.selectedDay}) : super(key: key);
  DateTime selectedDay;

  @override
  _DayHeader createState() => _DayHeader();
}

class _DayHeader extends State<DayHeader> with TickerProviderStateMixin {
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
        future: apiService.getTotalSchedule(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ScheduleTotalModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ScheduleTotalModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ScheduleTotalModel> contents) {
    getTotalContext(var item) {
      String total;
      if (item != null) {
        total =
            '${validateZero(item[0].content)} events and ${validateZero(item[0].task)} tasks';
      } else {
        total = '0 events and 0 tasks';
      }
      return total;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Column(
            children: [
              Text(
                DateFormat("EEE").format(widget.selectedDay),
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: textMD,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat("d").format(widget.selectedDay),
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: textLG,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTodayCalendarHeader(widget.selectedDay),
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: textLG,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getTotalContext(contents),
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: textSM,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
