import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/Models/Archive/Archive.dart';
import 'package:mi_fik/Modules/Models/Task.dart';
import 'package:mi_fik/Modules/Services/ArchieveServices.dart';
import 'package:mi_fik/Modules/Services/TaskServices.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class AddTaskwArchive extends StatefulWidget {
  AddTaskwArchive({Key key, this.text}) : super(key: key);
  String text;

  @override
  _AddTaskwArchive createState() => _AddTaskwArchive();
}

class _AddTaskwArchive extends State<AddTaskwArchive> {
  ArchieveService archiveService;
  TaskService taskService;

  //Initial variable
  final archiveNameCtrl = TextEditingController();
  final taskTitleCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;

  @override
  void initState() {
    super.initState();
    archiveService = ArchieveService();
    taskService = TaskService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool _isLoading = false;

    getDateText(date, type) {
      if (date != null) {
        return DateFormat("dd-MM-yy  HH:mm").format(date).toString();
      } else {
        return "Set Date $type";
      }
    }

    return SpeedDial(
        activeIcon: Icons.close,
        icon: Icons.add,
        iconTheme: IconThemeData(color: whitebg),
        backgroundColor: primaryColor,
        overlayColor: primaryColor,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.post_add_outlined),
            label: 'New Task',
            backgroundColor: primaryColor,
            foregroundColor: whitebg,
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: roundedLG, topRight: roundedLG)),
                barrierColor: primaryColor.withOpacity(0.5),
                isScrollControlled: true,
                builder: (BuildContext context) {
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
                              archiveNameCtrl.clear();
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
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
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
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
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
                                      minTime: DateTime(now.year, now.month,
                                          now.day), //Tomorrow
                                      maxTime: DateTime(
                                          now.year + 1, now.month, now.day),
                                      onConfirm: (date) {
                                    setState(() {
                                      dateStartCtrl = date;
                                    });
                                  }, currentTime: now, locale: LocaleType.en);
                                },
                                icon: const Icon(
                                  Icons.calendar_month,
                                  size: 24.0,
                                ),
                                label:
                                    Text(getDateText(dateStartCtrl, "Start")),
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 16),
                                    foregroundColor:
                                        primaryColor), // <-- TextButton
                                onPressed: () {
                                  final now = DateTime.now();

                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(now.year, now.month,
                                          now.day), //Tomorrow
                                      maxTime: DateTime(
                                          now.year + 1, now.month, now.day),
                                      onConfirm: (date) {
                                    setState(() {
                                      dateEndCtrl = date;
                                    });
                                  }, currentTime: now, locale: LocaleType.en);
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
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
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
                                    setState(() => _isLoading = false);
                                    if (isError) {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              FailedDialog(
                                                  text: "Create task failed"));
                                    } else {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              SuccessDialog(
                                                  text: "Create task success"));
                                    }
                                  });
                                } else {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FailedDialog(
                                              text:
                                                  "Create task failed, field can't be empty"));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        primaryColor),
                              ),
                              child: const Text('Done'),
                            ))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.folder),
            label: 'New Folder',
            backgroundColor: primaryColor,
            foregroundColor: whitebg,
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: roundedLG, topRight: roundedLG)),
                barrierColor: primaryColor.withOpacity(0.5),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Back',
                            onPressed: () {
                              archiveNameCtrl.clear();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Text("New Archive",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: textLG)),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: paddingXSM),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            cursorColor: Colors.white,
                            controller: archiveNameCtrl,
                            maxLength: 75,
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: 'Title',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
                                ),
                                fillColor: Colors.white,
                                filled: true),
                          ),
                        ),
                        SizedBox(
                            // transform: Matrix4.translationValues(
                            //     0.0, fullHeight * 0.94, 0.0),
                            width: fullWidth,
                            height: btnHeightMD,
                            child: ElevatedButton(
                              onPressed: () async {
                                //Mapping.
                                ArchiveModel archive = ArchiveModel(
                                  archieveName: archiveNameCtrl.text.toString(),
                                );

                                //Validator
                                if (archive.archieveName.isNotEmpty) {
                                  archiveService
                                      .addArchive(archive)
                                      .then((isError) {
                                    setState(() => _isLoading = false);
                                    if (isError) {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              FailedDialog(
                                                  text:
                                                      "Create archive failed"));
                                    } else {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              SuccessDialog(
                                                  text:
                                                      "Create archive success"));

                                      archiveNameCtrl.clear();
                                    }
                                  });
                                } else {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FailedDialog(
                                              text:
                                                  "Create archive failed, field can't be empty"));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        primaryColor),
                              ),
                              child: const Text('Done'),
                            ))
                      ],
                    ),
                  );
                },
              );
            },
          )
        ]);
  }
}
