import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_detail_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class DayEvent extends StatefulWidget {
  const DayEvent({Key key, this.item}) : super(key: key);
  final List item;

  @override
  StateDayEvent createState() => StateDayEvent();
}

class StateDayEvent extends State<DayEvent> with TickerProviderStateMixin {
  ContentCommandsService commandService;
  String hourChipBefore = "";
  String statusChipBefore = "";

  @override
  void initState() {
    super.initState();
    commandService = ContentCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    int index = 1;

    if (isOffline) {
      return SizedBox(
          height: fullHeight * 0.7,
          child: getMessageImageNoData(
              "assets/icon/badnet.png", "Failed to load data".tr, fullWidth));
    } else {
      return widget.item.isNotEmpty
          ? Column(
              children: widget.item.map<Widget>((e) {
              if (index < widget.item.length + 1) {
                if (index != widget.item.length) {
                  index++;
                  return _buildContentItem(e);
                } else {
                  index++;
                  return Column(children: [
                    _buildContentItem(e),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: spaceLG),
                        child: Text("No more item to show".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: textMD)))
                  ]);
                }
              } else {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: spaceLG),
                    child: Text("No more item to show".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: textMD)));
              }
            }).toList())
          : SizedBox(
              height: fullHeight * 0.7,
              child: getMessageImageNoData("assets/icon/empty.png",
                  "No event / task for today, have a good rest".tr, fullWidth));
    }
  }

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

  Widget _buildContentItem(ScheduleModel contents) {
    // double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    getChipHour(String ds, String de) {
      String now = DateTime.parse(ds).hour.toString();

      if (hourChipBefore == "" || hourChipBefore != now) {
        hourChipBefore = now;
        return getHourChipLine(ds, de, fullWidth);
      } else {
        return const SizedBox();
      }
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: spaceMD),
        child: Column(children: [
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
                              Get.to(() =>
                                  DetailPage(passSlug: contents.slugName));
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
        ]));
  }
}
