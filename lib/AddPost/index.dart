import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/AddPost/ChooseTag.dart';
import 'package:mi_fik/AddPost/SetLocation.dart';
import 'package:mi_fik/DB/Model/Content.dart';
import 'package:mi_fik/DB/Services/ContentServices.dart';
import 'package:mi_fik/Others/FailedDialog.dart';
import 'package:mi_fik/Others/SuccessDialog.dart';
import 'package:mi_fik/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class addPost extends StatefulWidget {
  const addPost({Key key}) : super(key: key);

  @override
  _addPost createState() => _addPost();
}

class _addPost extends State<addPost> {
  ContentService apiService;

  //Initial variable
  final contentTitleCtrl = TextEditingController();
  final contentDescCtrl = TextEditingController();
  DateTime dateStartCtrl = null;
  DateTime dateEndCtrl = null;

  @override
  void initState() {
    super.initState();
    apiService = ContentService();
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
        return "Set Date ${type}";
      }
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              height: fullHeight * 0.275,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/content/content-2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, fullHeight * 0.03, 0.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: iconLG),
              color: Colors.white,
              onPressed: () {
                //Empty all input
                selectedTag.clear();
                locDetailCtrl.clear();
                locCoordinateCtrl = null;
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: fullHeight * 0.25),
            height: fullHeight * 0.7,
            width: fullWidth,
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
          ),
          Container(
              transform: Matrix4.translationValues(0.0, fullHeight * 0.94, 0.0),
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  //Validate json.
                  validateNullJSON(val) {
                    if (val.length != 0) {
                      return jsonEncode(val);
                    } else {
                      return null;
                    }
                  }

                  validateDateNull(val) {
                    if (val != null) {
                      return val.toString();
                    } else {
                      return null;
                    }
                  }

                  //Get content location json
                  getContentLoc(detail, loc) {
                    if (detail != null && loc != null) {
                      var tag = [
                        {"type": "location", "detail": detail},
                        {"type": "coodinate", "detail": loc}
                      ];
                      return json.encode(tag);
                    } else {
                      return null;
                    }
                  }

                  //Mapping.
                  ContentModel content = ContentModel(
                    contentTitle: contentTitleCtrl.text.toString(),
                    contentSubtitle: "Lorem ipsum", //For now.
                    contentDesc: contentDescCtrl.text.toString(),
                    contentTag: validateNullJSON(selectedTag),
                    contentLoc: getContentLoc(
                        locDetailCtrl.text, locCoordinateCtrl), //For now.
                    contentAttach: null, //For now.
                    dateStart: validateDateNull(dateStartCtrl),
                    dateEnd: validateDateNull(dateEndCtrl),
                  );

                  //Validator
                  if (content.contentTitle.isNotEmpty &&
                      content.contentDesc.isNotEmpty) {
                    apiService.addContent(content).then((isError) {
                      setState(() => _isLoading = false);
                      if (isError) {
                        Navigator.pop(context);
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                FailedDialog(text: "Create content failed"));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SuccessDialog(text: "Create content success"));
                        // print("Success");

                        //Clear all variable
                        selectedTag.clear();
                        dateStartCtrl = null;
                        dateEndCtrl = null;
                        contentTitleCtrl.clear();
                        contentDescCtrl.clear();
                        locDetailCtrl.clear();
                        locCoordinateCtrl = null;
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
