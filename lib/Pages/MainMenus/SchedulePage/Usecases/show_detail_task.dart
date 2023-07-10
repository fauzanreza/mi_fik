import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/command_tasks.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_tasks.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/delete_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_saved_status.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/post_archive_rel.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({Key key, this.data}) : super(key: key);
  final ScheduleModel data;

  @override
  StateDetailTask createState() => StateDetailTask();
}

class StateDetailTask extends State<DetailTask> {
  TaskCommandsService taskService;

  //Initial variable
  final taskTitleCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;

  @override
  void initState() {
    super.initState();
    taskService = TaskCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    //Assign value to controller
    taskTitleCtrl.text = widget.data.contentTitle;
    taskDescCtrl.text = widget.data.contentDesc;

    dateStartCtrl ??= DateTime.parse(widget.data.dateStart);
    dateEndCtrl ??= DateTime.parse(widget.data.dateEnd);

    return SizedBox(
        height: 630,
        width: fullWidth,
        child: ListView(padding: EdgeInsets.zero, children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: spaceSM),
                  child: GetSavedStatus(
                      passSlug: widget.data.slugName, ctx: "Task")),
              const Spacer(),
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
            ],
          ),
          SizedBox(height: spaceLG),
          Container(
            padding: EdgeInsets.only(left: spaceXMD),
            child: getSubTitleMedium("Title", darkColor, TextAlign.start),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: spaceXMD),
            child: getInputText(75, taskTitleCtrl, false),
          ),
          Container(
            padding: EdgeInsets.only(left: spaceXMD),
            child: getSubTitleMedium(
                "Notes (Optional)", darkColor, TextAlign.start),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: spaceXMD),
            child: getInputDesc(255, 4, taskDescCtrl, false),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Wrap(
              runSpacing: -5,
              spacing: 5,
              children: [
                getDatePicker(
                    dateStartCtrl.subtract(
                        Duration(hours: getUTCHourOffset() * -1)), () {
                  final now = DateTime.now();

                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime:
                          DateTime(now.year, now.month, now.day), //Tomorrow
                      maxTime: DateTime(now.year + 1, now.month, now.day),
                      onConfirm: (date) {
                    setState(() {
                      dateStartCtrl =
                          date.add(Duration(hours: getUTCHourOffset() * -1));
                    });
                  },
                      currentTime: dateStartCtrl
                          .subtract(Duration(hours: getUTCHourOffset() * -1)),
                      locale: LocaleType.en);
                }, "Start", "datetime"),
                getDatePicker(
                    dateEndCtrl.subtract(
                        Duration(hours: getUTCHourOffset() * -1)), () {
                  final now = DateTime.now();

                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime:
                          DateTime(now.year, now.month, now.day), //Tomorrow
                      maxTime: DateTime(now.year + 1, now.month, now.day),
                      onConfirm: (date) {
                    setState(() {
                      dateEndCtrl =
                          date.add(Duration(hours: getUTCHourOffset() * -1));
                    });
                  },
                      currentTime: dateEndCtrl
                          .subtract(Duration(hours: getUTCHourOffset() * -1)),
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
                      child:
                          getDropDownMain(widget.data.reminder, reminderTypeOpt,
                              (String newValue) {
                        setState(() {
                          slctReminderType = newValue;
                        });
                      }, true, "reminder_")),
                  SizedBox(
                    width: spaceLG,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: warningBG),
                    tooltip: 'Delete Task',
                    onPressed: () {
                      Get.back();

                      showDialog<String>(
                          context: context,
                          barrierColor: primaryColor.withOpacity(0.5),
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                  insetPadding: EdgeInsets.all(spaceLG),
                                  contentPadding: EdgeInsets.all(spaceLG),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(roundedLG))),
                                  content: DeleteTask(
                                    id: widget.data.id,
                                    name: widget.data.contentTitle,
                                  ));
                            });
                          });
                    },
                  )
                ]),
                Container(
                    margin: EdgeInsets.only(top: spaceLG),
                    width: fullWidth,
                    height: btnHeightMD,
                    child: ElevatedButton(
                      onPressed: () async {
                        AddTaskModel task = AddTaskModel(
                            taskTitle: taskTitleCtrl.text.trim(),
                            taskDesc: taskDescCtrl.text.trim(),
                            dateStart: validateDatetime(dateStartCtrl),
                            dateEnd: validateDatetime(dateEndCtrl),
                            reminder: slctReminderType);

                        //Validator
                        if (task.taskTitle.isNotEmpty) {
                          taskService
                              .updateTask(task, widget.data.id)
                              .then((response) {
                            setState(() => {});
                            var status = response[0]['message'];
                            var body = response[0]['body'];

                            if (status == "success") {
                              Get.offNamed(CollectionRoute.bar,
                                  preventDuplicates: false);

                              Get.dialog(SuccessDialog(text: body));
                            } else {
                              Get.dialog(
                                  FailedDialog(text: body, type: "addtask"));
                            }
                          });
                        } else {
                          Get.dialog(const FailedDialog(
                              text:
                                  "Create archive failed, field can't be empty",
                              type: "addtask"));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(primaryColor),
                      ),
                      child: Text('Save Changes'.tr),
                    )),
                SizedBox(
                  height: spaceLG,
                ),
                PostArchiveRelation(
                    passSlug: widget.data.slugName, ctx: "Task"),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(spaceLG, spaceXMD, 0, 0),
              child: getSubTitleMedium(
                  "Created At : ${getItemTimeString(widget.data.createdAt)}",
                  shadowColor,
                  TextAlign.left)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceLG, spaceSM, 0, 0),
              child: getSubTitleMedium(
                  "Last Updated : ${getItemTimeString(widget.data.updatedAt)}",
                  shadowColor,
                  TextAlign.left))
        ]));
  }
}
