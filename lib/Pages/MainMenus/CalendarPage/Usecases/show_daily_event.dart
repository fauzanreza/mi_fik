import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Skeletons/content_2.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class DayEvent extends StatefulWidget {
  const DayEvent({Key key}) : super(key: key);

  @override
  _DayEvent createState() => _DayEvent();
}

class _DayEvent extends State<DayEvent> with TickerProviderStateMixin {
  ContentQueriesService apiService;
  String hourChipBefore;

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
        future: apiService.getSchedule(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ScheduleModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ScheduleModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton2();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ScheduleModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    if ((contents != null) && (contents.isNotEmpty)) {
      return Container(
          margin: const EdgeInsets.only(left: 15, top: 10),
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
              children: contents.map((content) {
            return Column(children: [
              getHourChip(content.dateStart, hourChipBefore, fullWidth),
              GetScheduleContainer(
                  width: fullWidth, content: content, ctx: context)
            ]);
          }).toList()));
    } else {
      return Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.asset('assets/icon/empty.png', width: fullWidth * 0.6),
              Text("No Event/Task for today, have a good rest",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: textMD))
            ],
          ));
    }
  }
}
