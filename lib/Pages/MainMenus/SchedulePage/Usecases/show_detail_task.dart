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
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/delete_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_saved_status.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/post_archive_rel.dart';

class DetailTask extends StatefulWidget {
  DetailTask({Key key, this.data}) : super(key: key);
  var data;

  @override
  _DetailTask createState() => _DetailTask();
}

class _DetailTask extends State<DetailTask> {
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
    bool isLoading = false;

    //Assign value to controller
    taskTitleCtrl.text = widget.data.contentTitle;
    taskDescCtrl.text = widget.data.contentDesc;

    dateStartCtrl ??= DateTime.parse(widget.data.dateStart);
    dateEndCtrl ??= DateTime.parse(widget.data.dateEnd);

    return SizedBox(
        height: 580,
        width: fullWidth,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: paddingXSM),
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
          SizedBox(height: paddingMD),
          Container(
            padding: EdgeInsets.only(left: paddingSM),
            child: getSubTitleMedium("Title", blackbg, TextAlign.start),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: paddingSM),
            child: getInputText(75, taskTitleCtrl, false),
          ),
          Container(
            padding: EdgeInsets.only(left: paddingSM),
            child:
                getSubTitleMedium("Notes (Optional)", blackbg, TextAlign.start),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: paddingSM),
            child: getInputDesc(255, 4, taskDescCtrl, false),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                    child: const Text('Reminder :'),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: paddingXSM),
                      child:
                          getDropDownMain(widget.data.reminder, reminderTypeOpt,
                              (String newValue) {
                        setState(() {
                          slctReminderType = newValue;
                        });
                      }, true, "reminder_")),
                  SizedBox(
                    width: paddingMD,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: dangerColor),
                    tooltip: 'Delete Task',
                    onPressed: () {
                      String id = widget.data.id;
                      Get.back();

                      showDialog<String>(
                          context: context,
                          barrierColor: primaryColor.withOpacity(0.5),
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                  insetPadding: EdgeInsets.all(paddingMD),
                                  contentPadding: EdgeInsets.all(paddingMD),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(roundedLG)),
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
                    margin: EdgeInsets.only(top: paddingMD),
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
                            setState(() => isLoading = false);
                            var status = response[0]['message'];
                            var body = response[0]['body'];

                            if (status == "success") {
                              Get.offAll(() => const BottomBar());

                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SuccessDialog(text: body));
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FailedDialog(
                                          text: body, type: "addtask"));
                            }
                          });
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => FailedDialog(
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
                  height: paddingMD,
                ),
                PostArchiveRelation(passSlug: widget.data.slugName, ctx: "Task")
              ],
            ),
          ),
        ]));
  }
}
