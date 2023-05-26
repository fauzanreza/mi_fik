import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Skeletons/content_2.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';

import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_detail_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({Key key}) : super(key: key);

  @override
  _MySchedulePage createState() => _MySchedulePage();
}

class _MySchedulePage extends State<MySchedulePage> {
  ContentQueriesService queryService;
  ContentCommandsService commandService;

  String hourChipBefore;

  @override
  void initState() {
    super.initState();
    queryService = ContentQueriesService();
    commandService = ContentCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: queryService.getSchedule(),
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
    bool isLoading;

    if ((contents != null) && (contents.isNotEmpty)) {
      return Container(
          margin: const EdgeInsets.only(left: 15, top: 10),
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: contents.map((content) {
                getChipHour(String ds) {
                  String now = DateTime.parse(ds).hour.toString();

                  if (hourChipBefore == "" || hourChipBefore != now) {
                    hourChipBefore = now;
                    return getHourChipLine(content.dateStart, fullWidth);
                  } else {
                    return const SizedBox();
                  }
                }

                return Column(children: [
                  getChipHour(content.dateStart),
                  SizedBox(
                      width: fullWidth,
                      child: IntrinsicHeight(
                          child: Stack(children: [
                        GestureDetector(
                            onTap: () {
                              if (content.dataFrom == 2) {
                                showDialog<String>(
                                    context: context,
                                    barrierColor: primaryColor.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                            insetPadding:
                                                EdgeInsets.all(paddingXSM),
                                            contentPadding:
                                                EdgeInsets.all(paddingXSM),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    roundedLG)),
                                            content: DetailTask(
                                              data: content,
                                            ));
                                      });
                                    });
                              } else {
                                commandService
                                    .postContentView(content.slugName)
                                    .then((response) {
                                  setState(() => isLoading = false);
                                  var status = response[0]['message'];
                                  var body = response[0]['body'];

                                  if (status == "success") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              passSlug: content.slugName)),
                                    );
                                  } else {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            FailedDialog(
                                                text: body, type: "openevent"));
                                  }
                                });

                                passSlugContent = content.slugName;
                              }
                            },
                            child: GetScheduleContainer(
                                width: fullWidth,
                                content: content,
                                ctx: context))
                      ])))
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
