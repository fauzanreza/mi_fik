import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Modules/Models/Task.dart';
import 'package:mi_fik/Modules/Services/TaskServices.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostTask extends StatefulWidget {
  PostTask({Key key, this.text}) : super(key: key);
  String text;

  @override
  _PostTask createState() => _PostTask();
}

class _PostTask extends State<PostTask> {
  TaskService taskService;

  //Initial variable
  final taskTitleCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;

  @override
  void initState() {
    super.initState();
    taskService = TaskService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    getDateText(date, type) {
      if (date != null) {
        return DateFormat("dd-MM-yy  HH:mm").format(date).toString();
      } else {
        return "Set Date $type";
      }
    }

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
                Navigator.pop(context);
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
                }, "Start"),
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
                }, "End"),
                Wrap(children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: const Color(0xFFFB8C00),
                    ),
                    onPressed: () {},
                    child: const Text('Reminder :'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: const Color(0xFFFB8C00),
                      side: const BorderSide(
                        width: 1.0,
                        color: Color(0xFFFB8C00),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onPressed: () {},
                    child: const Text('1 Hour Before'),
                  ),
                ]),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: paddingXSM),
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  validateDateNull(val) {
                    if (val != null) {
                      return val.toString();
                    } else {
                      return null;
                    }
                  }

                  //Mapping.
                  TaskModel task = TaskModel(
                    taskTitle: taskTitleCtrl.text.toString(),
                    taskDesc: taskDescCtrl.text.toString(),
                    dateStart: validateDateNull(dateStartCtrl),
                    dateEnd: validateDateNull(dateEndCtrl),
                  );

                  //Validator
                  if (task.taskTitle.isNotEmpty) {
                    taskService.addTask(task).then((isError) {
                      setState(() => isLoading = false);
                      if (isError) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                FailedDialog(text: "Create task failed"));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SuccessDialog(text: "Create task success"));
                      }
                    });
                  } else {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => FailedDialog(
                            text: "Create task failed, field can't be empty"));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(successbg),
                ),
                child: const Text('Done'),
              ))
        ],
      ),
    );
  }
}
