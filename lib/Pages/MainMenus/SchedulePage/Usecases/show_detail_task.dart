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
  const DetailTask({Key key, this.data, this.isModeled}) : super(key: key);
  final dynamic data;
  final bool isModeled;

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
    taskTitleCtrl.text = widget.isModeled == true
        ? widget.data.contentTitle
        : widget.data[0]['content_title'];
    taskDescCtrl.text = widget.isModeled == true
        ? widget.data.contentDesc
        : widget.data[0]['content_desc'];

    dateStartCtrl ??= DateTime.parse(widget.isModeled == true
        ? widget.data.dateStart
        : widget.data[0]['content_date_start']);
    dateEndCtrl ??= DateTime.parse(widget.isModeled == true
        ? widget.data.dateEnd
        : widget.data[0]['content_date_end']);

    return SizedBox(
        height: 630,
        width: fullWidth,
        child: ListView(padding: EdgeInsets.zero, children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: spaceSM),
                  child: GetSavedStatus(
                      passSlug: widget.isModeled == true
                          ? widget.data.slugName
                          : widget.data[0]['slug_name'],
                      ctx: "Task")),
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
            padding: EdgeInsets.fromLTRB(spaceLG, spaceSM, spaceLG, 0),
            child: Wrap(
              runSpacing: -spaceWrap,
              spacing: spaceWrap,
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
                  }, currentTime: dateStartCtrl, locale: LocaleType.en);
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
                  }, currentTime: dateEndCtrl, locale: LocaleType.en);
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
                          widget.isModeled == true
                              ? widget.data.reminder
                              : widget.data[0]['content_reminder'],
                          reminderTypeOpt, (String newValue) {
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
                                    id: widget.isModeled == true
                                        ? widget.data.id
                                        : widget.data[0]['id'],
                                    name: widget.isModeled == true
                                        ? widget.data.contentTitle
                                        : widget.data[0]['content_title'],
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
                            dateStart: validateDatetime(dateStartCtrl
                                .add(Duration(hours: getUTCHourOffset() * -1))),
                            dateEnd: validateDatetime(dateEndCtrl
                                .add(Duration(hours: getUTCHourOffset() * -1))),
                            reminder: slctReminderType);

                        //Validator
                        if (task.taskTitle.isNotEmpty) {
                          taskService
                              .updateTask(
                                  task,
                                  widget.isModeled == true
                                      ? widget.data.id
                                      : widget.data[0]['id'])
                              .then((response) {
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
                    passSlug: widget.isModeled == true
                        ? widget.data.slugName
                        : widget.data[0]['slug_name'],
                    ctx: "Task"),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(spaceLG, spaceXMD, 0, 0),
              child: getSubTitleMedium(
                  "Created At : ${getItemTimeString(widget.isModeled == true ? widget.data.createdAt : widget.data[0]['created_at'])}",
                  shadowColor,
                  TextAlign.left)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceLG, spaceSM, 0, 0),
              child: getSubTitleMedium(
                  "Last Updated : ${getItemTimeString(widget.isModeled == true ? widget.data.updatedAt : widget.data[0]['updated_at'])}",
                  shadowColor,
                  TextAlign.left))
        ]));
  }
}
