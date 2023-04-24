import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/Models/Task.dart';
import 'package:mi_fik/Modules/Services/TaskServices.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class DetailTask extends StatefulWidget {
  DetailTask(
      {Key key,
      this.id,
      this.taskTitlePass,
      this.taskDescPass,
      this.taskDateStartPass,
      this.taskDateEndPass})
      : super(key: key);
  String id;
  String taskTitlePass;
  String taskDescPass;
  String taskDateStartPass;
  String taskDateEndPass;

  @override
  _DetailTask createState() => _DetailTask();
}

class _DetailTask extends State<DetailTask> {
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
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    // bool _isLoading = false;

    getDateText(date, type) {
      if (date != null) {
        return DateFormat("dd-MM-yy  HH:mm").format(date).toString();
      } else {
        return "Set Date $type";
      }
    }

    //Assign value to controller
    taskTitleCtrl.text = widget.taskTitlePass;
    taskDescCtrl.text = widget.taskDescPass;

    dateStartCtrl ??= DateTime.parse(widget.taskDateStartPass);
    dateEndCtrl ??= DateTime.parse(widget.taskDateEndPass);

    return SizedBox(
        height:
            fullHeight * 0.6, //Pop up height based on fullwidth (Square maps).
        width: fullWidth,
        child: Column(children: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Back',
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomBar()),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text("Edit Task",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: textLG)),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: paddingXSM),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              cursorColor: Colors.white,
              controller: taskTitleCtrl,
              maxLength: 75,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Title',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFFB8C00)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFFB8C00)),
                  ),
                  fillColor: Colors.white,
                  filled: true),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextFormField(
              cursorColor: Colors.white,
              controller: taskDescCtrl,
              decoration: InputDecoration(
                  hintText: 'Notes (Optional)',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFFB8C00)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFFB8C00)),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              keyboardType: TextInputType.multiline,
              maxLines: 4,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Wrap(
              runSpacing: -5,
              spacing: 5,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    foregroundColor: const Color(0xFFFB8C00),
                  ), // <-- TextButton
                  onPressed: () {
                    final now = DateTime.now();

                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        currentTime: dateStartCtrl,
                        minTime:
                            DateTime(now.year, now.month, now.day), //Tomorrow
                        maxTime: DateTime(now.year + 1, now.month, now.day),
                        onConfirm: (date) {
                      setState(() {
                        dateStartCtrl = date;
                      });
                    }, locale: LocaleType.en);
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 24.0,
                  ),
                  label: Text(getDateText(dateStartCtrl, "Start")),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: primaryColor), // <-- TextButton
                  onPressed: () {
                    final now = DateTime.now();

                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime:
                            DateTime(now.year, now.month, now.day), //Tomorrow
                        currentTime: dateEndCtrl,
                        maxTime: DateTime(now.year + 1, now.month, now.day),
                        onConfirm: (date) {
                      setState(() {
                        dateEndCtrl = date;
                      });
                    }, locale: LocaleType.en);
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 24.0,
                  ),
                  label: Text(getDateText(dateEndCtrl, "End")),
                ),
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
                          taskService
                              .updateTask(task, int.parse(widget.id))
                              .then((isError) {
                            // setState(() => _isLoading = false);
                            if (isError) {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FailedDialog(text: "Update task failed"));
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SuccessDialog(
                                          text: "Update task success"));
                            }
                          });
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => FailedDialog(
                                  text:
                                      "Update task failed, field can't be empty"));
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
