import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/command_tasks.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_tasks.dart';
import 'package:mi_fik/Modules/Helpers/info.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostTask extends StatefulWidget {
  PostTask({Key key, this.text}) : super(key: key);
  String text;

  @override
  _PostTask createState() => _PostTask();
}

class _PostTask extends State<PostTask> {
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
    bool isLoading = false;

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
            child: Text("New Task",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: textLG)),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: Text("Title",
                  style: TextStyle(color: blackbg, fontSize: textMD))),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: getInputText(75, taskTitleCtrl, false)),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: Text("Notes (Optional)",
                  style: TextStyle(color: blackbg, fontSize: textMD))),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: getInputDesc(75, 5, taskDescCtrl, false)),
          Container(
            padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
            child: Wrap(
              runSpacing: -5,
              spacing: 5,
              children: [
                getDatePicker(dateStartCtrl, () {
                  final now = DateTime.now();

                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime:
                          DateTime(now.year, now.month, now.day), //Tomorrow
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
                      minTime:
                          DateTime(now.year, now.month, now.day), //Tomorrow
                      maxTime: DateTime(now.year + 1, now.month, now.day),
                      onConfirm: (date) {
                    setState(() {
                      dateEndCtrl = date;
                    });
                  }, currentTime: now, locale: LocaleType.en);
                }, "End", "datetime"),
                Wrap(children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: primaryColor,
                    ),
                    onPressed: () {},
                    child: const Text('Reminder :'),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: paddingXSM),
                      child: getDropDownMain(slctReminderType, reminderTypeOpt,
                          (String newValue) {
                        setState(() {
                          slctReminderType = newValue;
                        });
                      }, true, "reminder_")),
                ]),
                Container(
                    padding: EdgeInsets.fromLTRB(0, paddingMD, 0, 0),
                    child: GetInfoBox(
                      page: "homepage",
                      location: "add_task",
                    ))
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: paddingXSM),
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

                  if (data.taskTitle.isNotEmpty) {
                    taskService.addTask(data).then((response) {
                      setState(() => isLoading = false);
                      var status = response[0]['message'];
                      var body = response[0]['body'];

                      if (status == "success") {
                        Get.to(() => const BottomBar());

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
                        builder: (BuildContext context) => FailedDialog(
                            text: "Create archive failed, field can't be empty",
                            type: "addtask"));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(successbg),
                ),
                child: Text('Done'.tr),
              ))
        ],
      ),
    );
  }
}
