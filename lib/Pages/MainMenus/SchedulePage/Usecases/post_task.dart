import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
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
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostTask extends StatefulWidget {
  const PostTask({Key key, this.text}) : super(key: key);
  final String text;

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
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: fullHeight * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    transform: Matrix4.translationValues(
                        spaceXMD, fullHeight * 0.01, 0.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(roundedCircle)),
                      boxShadow: [
                        BoxShadow(
                          color: darkColor.withOpacity(0.35),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          offset: const Offset(
                            5.0,
                            5.0,
                          ),
                        )
                      ],
                    ),
                    child: IconButton(
                        icon: Icon(Icons.arrow_back, size: iconLG),
                        color: whiteColor,
                        onPressed: () => Get.back()),
                  ),
                )
              ]),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(top: spaceLG),
                      child: ListView(children: [
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                            alignment: Alignment.centerLeft,
                            child: getTitleLarge("New Task".tr, primaryColor)),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
                            child: Text("Title".tr,
                                style: TextStyle(
                                    color: darkColor, fontSize: textXMD))),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
                            child: getInputText(75, taskTitleCtrl, false)),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
                            child: Text("Notes (optional)".tr,
                                style: TextStyle(
                                    color: darkColor, fontSize: textXMD))),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
                            child: getInputDesc(75, 5, taskDescCtrl, false)),
                        Container(
                          padding:
                              EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
                          child: Wrap(
                            runSpacing: -spaceWrap,
                            spacing: spaceWrap,
                            children: [
                              getDatePicker(dateStartCtrl, () {
                                final now = DateTime.now();

                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime:
                                        DateTime(now.year, now.month, now.day),
                                    maxTime: DateTime(
                                        now.year + 1, now.month, now.day),
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
                                    maxTime: DateTime(
                                        now.year + 1, now.month, now.day),
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
                                    child: getDropDownMain(
                                        slctReminderType, reminderTypeOpt,
                                        (String newValue) {
                                      setState(() {
                                        slctReminderType = newValue;
                                      });
                                    }, true, "reminder_")),
                              ]),
                              Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0, spaceLG, 0, 0),
                                  child: const GetInfoBox(
                                    page: "homepage",
                                    location: "add_task",
                                  ))
                            ],
                          ),
                        )
                      ]))),
              SizedBox(
                  width: fullWidth,
                  height: btnHeightMD,
                  child: ElevatedButton(
                    onPressed: () async {
                      AddTaskModel data = AddTaskModel(
                          taskTitle: taskTitleCtrl.text.trim(),
                          taskDesc: taskDescCtrl.text.trim(),
                          dateStart: validateDatetime(dateStartCtrl
                              .add(Duration(hours: getUTCHourOffset() * -1))),
                          dateEnd: validateDatetime(dateEndCtrl
                              .add(Duration(hours: getUTCHourOffset() * -1))),
                          reminder: slctReminderType);

                      if (data.taskTitle.isNotEmpty &&
                          dateStartCtrl != null &&
                          dateEndCtrl != null) {
                        taskService.addTask(data).then((response) {
                          setState(() => {});
                          var status = response[0]['message'];
                          var body = response[0]['body'];

                          if (status == "success") {
                            Get.toNamed(CollectionRoute.bar,
                                preventDuplicates: false);

                            Get.dialog(SuccessDialog(text: body));
                          } else {
                            Get.dialog(
                                FailedDialog(text: body, type: "addtask"));
                          }
                        });
                      } else {
                        Get.dialog(FailedDialog(
                            text: "Create archive failed, field can't be empty"
                                .tr,
                            type: "addtask"));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(successBG),
                    ),
                    child: Text('Done'.tr, style: TextStyle(fontSize: textXMD)),
                  ))
            ],
          )),
    );
  }
}
