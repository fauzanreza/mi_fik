import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Skeletons/content_2.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';

import 'package:mi_fik/Modules/Variables/style.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({Key key}) : super(key: key);

  @override
  _MySchedulePage createState() => _MySchedulePage();
}

class _MySchedulePage extends State<MySchedulePage> {
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

    //Get total content in an archieve.
    getTotalArchieve(event, task) {
      if ((event != 0) && (task == 0)) {
        return "$event Events";
      } else if ((event == 0) && (task != 0)) {
        return "$task Task";
      } else {
        return "$event Events, $task Task";
      }
    }

    if ((contents != null) && (contents.isNotEmpty)) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: contents.map((content) {
            return SizedBox(
                width: fullWidth,
                child: IntrinsicHeight(
                    child: Stack(children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.05),
                    width: 2.5,
                    color: primaryColor,
                  ),
                  GetScheduleContainer(
                      width: fullWidth, content: content, ctx: context)
                ])));
          }).toList());
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
