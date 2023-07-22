import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_detail_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog(
      {Key key,
      this.slug,
      this.title,
      this.dateStart,
      this.isDirect,
      this.from,
      this.content})
      : super(key: key);
  final String slug;
  final bool isDirect;
  final String title;
  final String dateStart;
  final String from;
  final dynamic content;

  @override
  StateReminderDialog createState() => StateReminderDialog();
}

class StateReminderDialog extends State<ReminderDialog>
    with SingleTickerProviderStateMixin {
  ContentCommandsService commandService;
  AnimationController lottieController;

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(vsync: this);
    commandService = ContentCommandsService();
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Lottie.asset(
            "assets/json/reminder.json",
            controller: lottieController,
            repeat: true,
            filterQuality: FilterQuality.low,
            onLoaded: (composition) {
              lottieController
                ..duration = composition.duration
                ..forward();
            },
          ),
          Text(ucAll(widget.title),
              style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: textXLG)),
          SizedBox(height: spaceLG),
          Text("About to start in".tr,
              style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: textXMD)),
          Text(getReminderTimeRemain(widget.dateStart),
              style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: textLG)),
          Container(
              margin: EdgeInsets.only(top: spaceSM),
              padding: EdgeInsets.zero,
              width: fullWidth * 0.5,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.from == "event") {
                    final connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult != ConnectivityResult.none) {
                      commandService
                          .postContentView(widget.slug)
                          .then((response) {
                        setState(() => {});
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Get.to(() => DetailPage(passSlug: widget.slug));
                        } else {
                          Get.dialog(
                              FailedDialog(text: body, type: "openevent"));
                        }
                      });
                    } else {
                      Get.to(() => DetailPage(passSlug: widget.slug));
                    }

                    passSlugContent = widget.slug;
                  } else {
                    Get.back();
                    showDialog<String>(
                        context: context,
                        barrierColor: primaryColor.withOpacity(0.5),
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                                insetPadding: EdgeInsets.all(spaceSM),
                                contentPadding: EdgeInsets.all(spaceSM),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(roundedLG))),
                                content: DetailTask(
                                  data: widget.content,
                                  isModeled: false,
                                ));
                          });
                        });
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(roundedMD),
                  )),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(primaryColor),
                ),
                child: Text('Detail'.tr, style: TextStyle(fontSize: textMD)),
              )),
        ]));
  }
}
