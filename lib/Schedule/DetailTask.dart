import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/main.dart';

class DetailTask extends StatefulWidget {
  DetailTask(
      {Key key,
      this.taskTitle,
      this.taskDesc,
      this.taskDateStart,
      this.taskDateEnd})
      : super(key: key);
  String taskTitle;
  String taskDesc;
  String taskDateStart;
  String taskDateEnd;

  @override
  _DetailTask createState() => _DetailTask();
}

class _DetailTask extends State<DetailTask> {
  //Initial variable
  final taskTitleCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();
  DateTime dateStartCtrl = null;
  DateTime dateEndCtrl = null;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    getDateText(date, type) {
      if (date != null) {
        return DateFormat("dd-MM-yy  HH:mm").format(date).toString();
      } else {
        return "Set Date ${type}";
      }
    }

    //Assign value to controller
    taskTitleCtrl.text = widget.taskTitle;
    taskDescCtrl.text = widget.taskDesc;
    dateStartCtrl = DateTime.parse(widget.taskDateStart);
    dateEndCtrl = DateTime.parse(widget.taskDateEnd);

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
                Navigator.pop(context);
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
                Container(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: const Color(0xFFFB8C00),
                    ), // <-- TextButton
                    onPressed: () {
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
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 24.0,
                    ),
                    label: Text(getDateText(dateStartCtrl, "Start")),
                  ),
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
                        maxTime: DateTime(now.year + 1, now.month, now.day),
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
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onPressed: () {},
                    child: const Text('1 Hour Before'),
                  ),
                ]),
              ],
            ),
          ),
        ]));
  }
}
