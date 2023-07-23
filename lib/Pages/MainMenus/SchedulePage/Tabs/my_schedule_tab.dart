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

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({Key key}) : super(key: key);

  @override
  StateMySchedulePage createState() => StateMySchedulePage();
}

class StateMySchedulePage extends State<MySchedulePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ScrollController scrollCtrl;

  ContentQueriesService queryService;
  ContentCommandsService commandService;
  String hourChipBefore = "";
  String statusChipBefore = "";
  int page = 1;
  int totalPage = 1;
  List<ScheduleModel> contents = [];
  bool isLoading = false;
  bool isEmpty = false;

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
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    if (isOffline) {
      return SizedBox(
          height: fullHeight * 0.7,
          child: getMessageImageNoData(
              "assets/icon/badnet.png", "Failed to load data".tr, fullWidth));
    } else {
      return SafeArea(
        key: _refreshIndicatorKey,
        maintainBottomViewPadding: false,
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: contents.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(spaceMD, 0, spaceMD, spaceXMD),
                  itemCount: contents.length + 1,
                  controller: scrollCtrl,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < contents.length) {
                      return _buildListView(contents[index]);
                    } else if (isLoading) {
                      return const ContentSkeleton2();
                    } else {
                      return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: spaceLG),
                          child: Text("No more item to show".tr,
                              style: TextStyle(fontSize: textSM)));
                    }
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  height: fullHeight * 0.7,
                  child: getMessageImageNoData(
                      "assets/icon/empty.png",
                      "No event / task for today, have a good rest".tr,
                      fullWidth)),
        ),
      );
    }
  }

  @override
  void dispose() {
    //scrollCtrl.dispose();
    super.dispose();
  }

  Widget _buildListView(ScheduleModel contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

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
        getDateChip(contents.dateStart, contents.dateEnd),
        getChipHour(contents.dateStart, contents.dateEnd),
        SizedBox(
            width: fullWidth,
            child: IntrinsicHeight(
                child: Stack(children: [
              GestureDetector(
                  onTap: () async {
                    if (contents.dataFrom == 2) {
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
                                    data: contents,
                                    isModeled: true,
                                  ));
                            });
                          });
                    } else {
                      final connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult != ConnectivityResult.none) {
                        commandService
                            .postContentView(contents.slugName)
                            .then((response) {
                          setState(() => {});
                          var status = response[0]['message'];
                          var body = response[0]['body'];

                          if (status == "success") {
                            Get.to(
                                () => DetailPage(passSlug: contents.slugName));
                          } else {
                            Get.dialog(
                                FailedDialog(text: body, type: "openevent"));
                          }
                        });
                      } else {
                        Get.to(() => DetailPage(passSlug: contents.slugName));
                      }

                      passSlugContent = contents.slugName;
                    }
                  },
                  child: GetScheduleContainer(
                      width: fullWidth, content: contents, isConverted: true))
            ])))
      ]);
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
