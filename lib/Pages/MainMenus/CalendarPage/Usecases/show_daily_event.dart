import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Skeletons/content_2.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';

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
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
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
      return SizedBox(
          height: fullHeight * 0.7,
          child: getMessageImageNoData("assets/icon/empty.png",
              "No event / task for today, have a good rest", fullWidth));
    }
  }
}
