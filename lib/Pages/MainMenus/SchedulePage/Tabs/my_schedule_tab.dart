import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  StateMySchedulePage createState() => StateMySchedulePage();
}

class StateMySchedulePage extends State<MySchedulePage> {
  ContentQueriesService queryService;
  ContentCommandsService commandService;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> refreshData() async {
    setState(() {});
  }

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
        future: queryService.getSchedule(slctSchedule),
        builder: (BuildContext context,
            AsyncSnapshot<List<ScheduleModel>> snapshot) {
          if (snapshot.hasError) {
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
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
    String hourChipBefore = "";
    String dateChipBefore = "";

    Widget getDateChip(ds) {
      var date = DateTime.parse(ds);

      String check = ("${date.year}${date.month}${date.day}");
      if (dateChipBefore != check) {
        dateChipBefore = check;
        var dateContext = DateFormat("dd MMM yyyy").format(date);
        var yesterdayContext =
            DateFormat("dd MMM yyyy").format(date.add(const Duration(days: 1)));

        if (getToday("date") == dateContext) {
          dateContext = "Today".tr;
        } else if (getToday("date") == yesterdayContext) {
          dateContext = "Yesterday".tr;
        }

        return Container(
            margin: EdgeInsets.symmetric(vertical: spaceMD),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: spaceSM - 2),
            width: 135,
            decoration: const BoxDecoration(
                color: Color(0xFFFADFB9),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child:
                Text("From $dateContext", style: TextStyle(fontSize: textSM)));
      } else {
        return const SizedBox();
      }
    }

    if ((contents != null) && (contents.isNotEmpty)) {
      return RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refreshData,
          child: ListView(
              padding: EdgeInsets.only(bottom: spaceJumbo, left: spaceXMD),
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
                  getDateChip(content.dateStart),
                  getChipHour(content.dateStart),
                  SizedBox(
                      width: fullWidth,
                      child: IntrinsicHeight(
                          child: Stack(children: [
                        GestureDetector(
                            onTap: () async {
                              if (content.dataFrom == 2) {
                                showDialog<String>(
                                    context: context,
                                    barrierColor: primaryColor.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                            insetPadding:
                                                EdgeInsets.all(spaceSM),
                                            contentPadding:
                                                EdgeInsets.all(spaceSM),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        roundedLG))),
                                            content: DetailTask(
                                              data: content,
                                              isModeled: true,
                                            ));
                                      });
                                    });
                              } else {
                                final connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult !=
                                    ConnectivityResult.none) {
                                  commandService
                                      .postContentView(content.slugName)
                                      .then((response) {
                                    setState(() => {});
                                    var status = response[0]['message'];
                                    var body = response[0]['body'];

                                    if (status == "success") {
                                      Get.to(() => DetailPage(
                                          passSlug: content.slugName));
                                    } else {
                                      Get.dialog(FailedDialog(
                                          text: body, type: "openevent"));
                                    }
                                  });
                                } else {
                                  Get.to(() =>
                                      DetailPage(passSlug: content.slugName));
                                }

                                passSlugContent = content.slugName;
                              }
                            },
                            child: GetScheduleContainer(
                                width: fullWidth,
                                content: content,
                                isConverted: true))
                      ])))
                ]);
              }).toList()));
    } else {
      if (isOffline) {
        return SizedBox(
            height: fullHeight * 0.7,
            child: getMessageImageNoData(
                "assets/icon/badnet.png", "Failed to load data".tr, fullWidth));
      } else {
        return SizedBox(
            height: fullHeight * 0.7,
            child: getMessageImageNoData("assets/icon/empty.png",
                "No event / task for today, have a good rest".tr, fullWidth));
      }
    }
  }
}
