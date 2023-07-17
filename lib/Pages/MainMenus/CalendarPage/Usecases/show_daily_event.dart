import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class DayEvent extends StatefulWidget {
  const DayEvent({Key key}) : super(key: key);

  @override
  StateDayEvent createState() => StateDayEvent();
}

class StateDayEvent extends State<DayEvent> with TickerProviderStateMixin {
  ContentQueriesService queryService;
  ContentCommandsService commandService;

  String hourChipBefore = "";

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
        future: queryService.getSchedule(slctCalendar),
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
    String statusChipBefore = "";

    Widget getDateChip(ds, de) {
      var dStart = DateTime.parse(ds);
      var dEnd = DateTime.parse(de);
      var now = DateTime.now();
      String dateContext;
      Color clr;

      DateTime checkStart = DateTime(dStart.year, dStart.month, dStart.day);
      DateTime checkEnd = DateTime(dEnd.year, dEnd.month, dEnd.day);
      DateTime today = DateTime(now.year, now.month, now.day);

      if (checkStart.isBefore(today) || checkStart == today) {
        if ((checkStart.isBefore(today) && checkEnd.isAfter(today)) ||
            // ignore: unrelated_type_equality_checks
            (checkStart == today && checkStart.hour == 0 && checkEnd == 24)) {
          dateContext = "All Day".tr;
          clr = warningBG;
        } else if (checkStart.isBefore(today) && checkEnd == today) {
          dateContext = "Ends Today".tr;
          clr = warningBG;
        } else {
          dateContext = "Just Started Today".tr;
          clr = successBG;
        }

        if (statusChipBefore == "" || statusChipBefore != dateContext) {
          statusChipBefore = dateContext;

          return Container(
              margin: EdgeInsets.only(top: spaceMD),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.circle, size: 14, color: clr),
                    ),
                    TextSpan(
                        text: " $dateContext",
                        style: TextStyle(
                            color: clr,
                            fontSize: textXMD,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ));
        } else {
          return const SizedBox();
        }
      } else {
        return const SizedBox();
      }
    }

    if (contents != null) {
      return Container(
          margin: EdgeInsets.only(left: spaceXMD, top: spaceSM),
          padding: EdgeInsets.only(bottom: spaceXMD),
          child: Column(
              children: contents.map((content) {
            getChipHour(String ds, String de) {
              String now = DateTime.parse(ds).hour.toString();

              if (hourChipBefore == "" || hourChipBefore != now) {
                hourChipBefore = now;
                return getHourChipLine(ds, de, fullWidth);
              } else {
                return const SizedBox();
              }
            }

            return Column(children: [
              getDateChip(content.dateStart, content.dateEnd),
              getChipHour(content.dateStart, content.dateEnd),
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
                                        insetPadding: EdgeInsets.all(spaceSM),
                                        contentPadding: EdgeInsets.all(spaceSM),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(roundedLG))),
                                        content: DetailTask(
                                          data: content,
                                          isModeled: true,
                                        ));
                                  });
                                });
                          } else {
                            final connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult != ConnectivityResult.none) {
                              commandService
                                  .postContentView(content.slugName)
                                  .then((response) {
                                setState(() => {});
                                var status = response[0]['message'];
                                var body = response[0]['body'];

                                if (status == "success") {
                                  Get.to(() =>
                                      DetailPage(passSlug: content.slugName));
                                } else {
                                  Get.dialog(FailedDialog(
                                      text: body, type: "openevent"));
                                }
                              });
                            } else {
                              Get.to(
                                  () => DetailPage(passSlug: content.slugName));
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
