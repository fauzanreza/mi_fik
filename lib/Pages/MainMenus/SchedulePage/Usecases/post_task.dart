import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/command_tasks.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_tasks.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/info.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostTask extends StatefulWidget {
  PostTask({Key key, this.text}) : super(key: key);
  String text;

  @override
  StatePostTask createState() => StatePostTask();
}

class StatePostTask extends State<PostTask> {
  TaskCommandsService taskService;

  final taskTitleCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;

  @override
  void dispose() {
    taskTitleCtrl.dispose();
    taskDescCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    taskService = TaskCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Back',
              onPressed: () {
                Get.back();
              },
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.centerLeft,
              child: getTitleLarge("New Task".tr, primaryColor)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              child: Text("Title".tr,
                  style: TextStyle(color: darkColor, fontSize: textXMD))),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              child: getInputText(75, taskTitleCtrl, false)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              child: Text("Notes (optional)".tr,
                  style: TextStyle(color: darkColor, fontSize: textXMD))),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              child: getInputDesc(75, 5, taskDescCtrl, false)),
          Container(
            padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
            child: Wrap(
              runSpacing: -5,
              spacing: 5,
              children: [
                getDatePicker(dateStartCtrl, () {
                  final now = DateTime.now();

                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(now.year, now.month, now.day),
                      maxTime: DateTime(now.year + 1, now.month, now.day),
                      onConfirm: (date) {
                    setState(() {
                      dateStartCtrl = date;
                    });
                  }, currentTime: now, locale: LocaleType.en);
                }, "Start", "datetime"),
                getDatePicker(dateEndCtrl, () {
                  final now = DateTime.now();

                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: getMinEndTime(dateStartCtrl),
                      maxTime: DateTime(now.year + 1, now.month, now.day),
                      onConfirm: (date) {
                    setState(() {
                      dateEndCtrl = date;
                    });
                  },
                      currentTime: getMinEndTime(dateStartCtrl),
                      locale: LocaleType.en);
                }, "End", "datetime"),
                Wrap(children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: primaryColor,
                    ),
                    onPressed: () {},
                    child: Text('Reminder'.tr),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: spaceSM),
                      child: getDropDownMain(slctReminderType, reminderTypeOpt,
                          (String newValue) {
                        setState(() {
                          slctReminderType = newValue;
                        });
                      }, true, "reminder_")),
                ]),
                Container(
                    padding: EdgeInsets.fromLTRB(0, spaceLG, 0, 0),
                    child: const GetInfoBox(
                      page: "homepage",
                      location: "add_task",
                    ))
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: spaceSM),
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  AddTaskModel data = AddTaskModel(
                      taskTitle: taskTitleCtrl.text.trim(),
                      taskDesc: taskDescCtrl.text.trim(),
                      dateStart: validateDatetime(dateStartCtrl),
                      dateEnd: validateDatetime(dateEndCtrl),
                      reminder: slctReminderType);

                  if (data.taskTitle.isNotEmpty &&
                      dateStartCtrl != null &&
                      dateEndCtrl != null) {
                    taskService.addTask(data).then((response) {
                      setState(() => {});
                      var status = response[0]['message'];
                      var body = response[0]['body'];

                      if (status == "success") {
                        Get.offAll(const BottomBar());

                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SuccessDialog(text: body));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                FailedDialog(text: body, type: "addtask"));
                      }
                    });
                  } else {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => const FailedDialog(
                            text: "Create archive failed, field can't be empty",
                            type: "addtask"));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(successBG),
                ),
                child: Text('Done'.tr, style: TextStyle(fontSize: textXMD)),
              ))
        ],
      ),
    );
  }
}
