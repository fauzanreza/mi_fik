import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/command_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';

import 'package:mi_fik/Modules/Variables/dummy.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Usecases/set_image.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Usecases/set_location.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Usecases/set_tag.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key key}) : super(key: key);

  @override
  _AddPost createState() => _AddPost();
}

class _AddPost extends State<AddPost> {
  String result = '';

  ContentCommandsService apiCommand;

  //Initial variable
  final contentTitleCtrl = TextEditingController();
  final contentDescCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;

  @override
  void initState() {
    super.initState();
    apiCommand = ContentCommandsService();
  }

  @override
  void dispose() {
    super.dispose();
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

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Stack(children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: fullHeight * 0.25,
                    transform: Matrix4.translationValues(0.0, 15, 0.0),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icon/default_content.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SetImageAttachment()
              ],
            ),
            Container(
              transform: Matrix4.translationValues(
                  fullWidth * 0.03, fullHeight * 0.05, 0.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 67, 67, 67).withOpacity(0.3),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                    offset: const Offset(
                      5.0,
                      5.0,
                    ),
                  )
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: iconLG),
                color: whitebg,
                onPressed: () async {
                  //Empty all input
                  if (selectedTag.isNotEmpty ||
                      locDetailCtrl.text.isNotEmpty ||
                      locCoordinateCtrl != null ||
                      contentTitleCtrl.text.isNotEmpty ||
                      contentDescCtrl != null ||
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
                                                    backgroundColor: dangerColor
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
              color: whitebg,
            ),
            child: ListView(padding: EdgeInsets.zero, children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: getSubTitleMedium("Title", blackbg),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: getInputText(75, contentTitleCtrl, false),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: getSubTitleMedium("Description", blackbg),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: getInputDesc(10000, 5, contentDescCtrl, false),
              ),
              Container(
                  margin: EdgeInsets.only(left: paddingMD),
                  padding: EdgeInsets.only(top: paddingXSM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Event Tag",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: blackbg,
                            fontWeight: FontWeight.w500,
                          )),
                      const ChooseTag(),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reminder :',
                                style: TextStyle(fontSize: textSM)),
                            Container(
                                padding: EdgeInsets.only(left: paddingXSM),
                                child: getDropDownMain(
                                    slctReminderType, reminderTypeOpt,
                                    (String newValue) {
                                  setState(() {
                                    slctReminderType = newValue;
                                  });
                                }, true, "reminder_")),
                          ]),
                      // Info or help
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text('ex : URL, Video, Image, Doc',
                                    style: TextStyle(fontSize: textSM))),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                              child: SizedBox(
                                width: 180,
                                height: 40,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    backgroundColor: whitebg,
                                    side: BorderSide(
                                      width: 1.0,
                                      color: primaryColor,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  onPressed: () async {
                                    FilePickerResult result = await FilePicker
                                        .platform
                                        .pickFiles(allowMultiple: true);
                                  },
                                  icon: const Icon(Icons
                                      .attach_file), //icon data for elevated button
                                  label: const Text("Insert Attachment"),
                                  //label text
                                ),
                              ),
                            ),
                          ])
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(children: [
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
                    }, "Start", "datetime"),
                    const Spacer(),
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
                    }, "End", "datetime"),
                  ])),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(children: [
                    const SetLocation(),
                  ]))
            ]),
          )),
          SizedBox(
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  if (dateStartCtrl != null || dateEndCtrl != null) {
                    ContentModel content = ContentModel(
                      userId: passIdUser,
                      contentTitle: contentTitleCtrl.text.toString(),
                      contentDesc: contentDescCtrl.text.toString(),
                      contentTag: validateNullJSON(selectedTag),
                      contentLoc: getContentLocObj(
                          locDetailCtrl.text, locCoordinateCtrl),
                      contentAttach: null,
                      contentImage: null,
                      reminder: "reminder_none",
                      dateStart: getDBDateFormat("date", dateStartCtrl),
                      dateEnd: getDBDateFormat("date", dateStartCtrl),
                      timeStart: getDBDateFormat("time", dateEndCtrl),
                      timeEnd: getDBDateFormat("time", dateEndCtrl),
                      isDraft: 0,
                    );

                    if (content.contentTag != null) {
                      if (content.contentTitle.isNotEmpty &&
                          content.contentDesc.isNotEmpty) {
                        apiCommand.postContent(content).then((response) {
                          setState(() => isLoading = false);
                          var status = response[0]['message'];
                          var body = response[0]['body'];

                          if (status == "success") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomBar()),
                            );
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    SuccessDialog(text: body));
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    FailedDialog(text: body, type: "addevent"));
                          }
                        });
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => FailedDialog(
                                text:
                                    "Create archive failed, field can't be empty",
                                type: "addevent"));
                      }
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => FailedDialog(
                              text:
                                  "Create archive failed, tag must be selected",
                              type: "addevent"));
                    }
                  } else {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => FailedDialog(
                            text:
                                "Create archive failed, date period must be selected",
                            type: "addevent"));
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
