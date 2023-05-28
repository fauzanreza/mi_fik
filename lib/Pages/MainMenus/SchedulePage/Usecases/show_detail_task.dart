import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    getDateText(date, type) {
      if (date != null) {
        return DateFormat("dd-MM-yy  HH:mm").format(date).toString();
      } else {
        return "Set Date $type";
      }
    }

    //Assign value to controller
    taskTitleCtrl.text = widget.data.contentTitle;
    taskDescCtrl.text = widget.data.contentDesc;

    dateStartCtrl ??= DateTime.parse(widget.data.dateStart);
    dateEndCtrl ??= DateTime.parse(widget.data.dateEnd);

    return SizedBox(
        height: 500,
        width: fullWidth,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Back',
              onPressed: () {
                Get.to(() => const BottomBar());
              },
            ),
          ),
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
                              Get.to(() => const BottomBar());

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
                      child: const Text('Save'),
                    ))
              ],
            ),
          ),
        ]));
  }
}
