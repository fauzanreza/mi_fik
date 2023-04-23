import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/Modules/Services/Commands/ContentCommands.dart';
import 'package:mi_fik/Modules/Services/Queries/ContentQueries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/ChooseTag.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/SetLocation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class addPost extends StatefulWidget {
  const addPost({Key key}) : super(key: key);

  @override
  _addPost createState() => _addPost();
}

class _addPost extends State<addPost> {
  ContentQueriesService apiQuery;
  ContentCommandsService apiCommand;

  //Initial variable
  final contentTitleCtrl = TextEditingController();
  final contentDescCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;

  @override
  void initState() {
    super.initState();
    apiQuery = ContentQueriesService();
    apiCommand = ContentCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool _isLoading = false;

    getDateText(date, type) {
      if (date != null) {
        return DateFormat("dd-MM-yy  HH:mm").format(date).toString();
      } else {
        return "Set Date $type";
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Stack(children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: fullHeight * 0.25,
                transform: Matrix4.translationValues(0.0, 15, 0.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/content/content-2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              transform:
                  Matrix4.translationValues(0.0, fullHeight * 0.045, 0.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: iconLG),
                color: Colors.white,
                onPressed: () {
                  //Empty all input
                  if (selectedTag.isNotEmpty ||
                      locDetailCtrl.text.isNotEmpty ||
                      locCoordinateCtrl != null ||
                      contentTitleCtrl.text.isNotEmpty ||
                      contentDescCtrl.text.isNotEmpty ||
                      dateStartCtrl != null ||
                      dateEndCtrl != null) {
                    return showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                                insetPadding: EdgeInsets.all(paddingSM),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: paddingMD,
                                    vertical: paddingMD * 1.5),
                                content: SizedBox(
                                    height: 120,
                                    width: fullWidth,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "Are you sure want to leave? All changes will not be saved",
                                              style: TextStyle(
                                                  color: blackbg,
                                                  fontSize: textMD,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.8),
                                                    padding: EdgeInsets.all(
                                                        paddingMD * 0.8)),
                                                onPressed: () {
                                                  selectedTag.clear();
                                                  locDetailCtrl.clear();
                                                  locCoordinateCtrl = null;
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Yes, Discard Change",
                                                  style: TextStyle(
                                                    color: whitebg,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        primaryColor,
                                                    padding: EdgeInsets.all(
                                                        paddingMD * 0.8)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: whitebg,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ])));
                          });
                        });
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ]),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: paddingMD),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(roundedLG2),
              color: Colors.white,
            ),
            child: ListView(padding: EdgeInsets.zero, children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  cursorColor: Colors.white,
                  controller: contentTitleCtrl,
                  maxLength: 75,
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
                  controller: contentDescCtrl,
                  decoration: InputDecoration(
                      hintText: 'Content',
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
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: SizedBox(
                  width: 180, // <-- Your width
                  height: 40,
                  child: ElevatedButton.icon(
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
                    onPressed: () async {
                      FilePickerResult result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);
                    },
                    icon: const Icon(
                        Icons.attach_file), //icon data for elevated button
                    label: const Text("Insert Attachment"),
                    //label text
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: paddingMD),
                  padding: EdgeInsets.only(top: paddingXSM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Choose Tags",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xFFFB8C00),
                            fontWeight: FontWeight.w500,
                          )),
                      Container(
                          transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                          child: const ChooseTag()),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Wrap(runSpacing: -5, spacing: 5, children: [
                    const SetLocationButton(),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        foregroundColor: const Color(0xFFFB8C00),
                      ), // <-- TextButton
                      onPressed: () {
                        final now = DateTime.now();

                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(
                                now.year, now.month, now.day), //Tomorrow
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
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 16),
                          foregroundColor: primaryColor), // <-- TextButton
                      onPressed: () {
                        final now = DateTime.now();

                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(
                                now.year, now.month, now.day), //Tomorrow
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
                    ])
                  ])),
            ]),
          )),
          SizedBox(
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  //Mapping.
                  ContentModel content = ContentModel(
                    userId: passIdUser,
                    contentTitle: contentTitleCtrl.text.toString(),
                    contentDesc: contentDescCtrl.text.toString(),
                    contentTag: validateNullJSON(selectedTag),
                    contentLoc:
                        getContentLocObj(locDetailCtrl.text, locCoordinateCtrl),
                    contentAttach: null,
                    contentImage: null,
                    reminder: "reminder_none",
                    dateStart:
                        validateNull(getDBDateFormat("date", dateStartCtrl)),
                    dateEnd:
                        validateNull(getDBDateFormat("date", dateStartCtrl)),
                    timeStart:
                        validateNull(getDBDateFormat("time", dateEndCtrl)),
                    timeEnd: validateNull(getDBDateFormat("time", dateEndCtrl)),
                    isDraft: 0,
                  );

                  //Validator
                  if (content.contentTitle.isNotEmpty &&
                      content.contentDesc.isNotEmpty) {
                    apiCommand.addContent(content).then((isError) {
                      setState(() => _isLoading = false);
                      if (isError) {
                        Navigator.pop(context);
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                FailedDialog(text: "Create content failed"));
                      } else {
                        print(json.encode(content));

                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SuccessDialog(text: "Create content success"));

                        //Clear all variable
                        // selectedTag.clear();
                        // dateStartCtrl = null;
                        // dateEndCtrl = null;
                        // contentTitleCtrl.clear();
                        // contentDescCtrl.clear();
                        // locDetailCtrl.clear();
                        // locCoordinateCtrl = null;
                      }
                    });
                  } else {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => FailedDialog(
                            text:
                                "Create content failed, field can't be empty"));
                  }

                  // print(jsonEncode(selectedTag).toString());
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(primaryColor),
                ),
                child: const Text('Save Event'),
              ))
        ],
      ),
    );
  }
}
