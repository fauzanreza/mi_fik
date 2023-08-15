import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/command_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/info.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';

import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Components/set_attachment.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Components/set_image.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Components/set_location.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Components/set_tag.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key key}) : super(key: key);

  @override
  StateAddPost createState() => StateAddPost();
}

class StateAddPost extends State<AddPost> {
  String result = '';
  String eventPeriodMsg = '';
  String eventTagMsg = '';
  String eventTitleMsg = '';
  String eventDescMsg = '';
  String allMsg = '';
  bool isLoadPost = false;

  ContentCommandsService apiCommand;

  //Initial variable
  final contentTitleCtrl = TextEditingController();
  final contentDescCtrl = TextEditingController();
  final locDetailCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;
  List<String> localeReminder;

  @override
  void initState() {
    super.initState();
    apiCommand = ContentCommandsService();
    localeReminder = reminderTypeOpt;
  }

  @override
  void dispose() {
    locDetailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    getDiscard() {
      //Empty all input
      if (selectedTag.isNotEmpty ||
          locDetailCtrl.text.trim().isNotEmpty ||
          locCoordinateCtrl != null ||
          contentTitleCtrl.text.trim().isNotEmpty ||
          contentDescCtrl.text.trim().isNotEmpty ||
          dateStartCtrl != null ||
          contentAttImage != null ||
          dateEndCtrl != null) {
        return showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    insetPadding: EdgeInsets.all(spaceXMD),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: spaceLG, vertical: spaceLG * 1.5),
                    content: SizedBox(
                        height: 120,
                        width: fullWidth,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Are you sure want to leave? All changes will not be saved"
                                      .tr,
                                  style: TextStyle(
                                      color: darkColor,
                                      fontSize: textXMD,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            warningBG.withOpacity(0.8),
                                        padding: EdgeInsets.all(spaceLG * 0.8)),
                                    onPressed: () {
                                      selectedTag.clear();
                                      locDetailCtrl.clear();
                                      locCoordinateCtrl = null;
                                      contentAttImage = null;
                                      listAttachment = [];
                                      Get.back();
                                      Get.back();
                                    },
                                    child: Text(
                                      "Yes, Discard Change".tr,
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.all(spaceLG * 0.8)),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "Cancel".tr,
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ])));
              });
            });
      } else {
        Get.back();
      }
    }

    getReminderBasedPeriod(int remain) {
      localeReminder.clear();
      localeReminder.add("reminder_none");

      if (remain > 0) {
        localeReminder.add("reminder_1_hour_before");
      }
      if (remain > 180) {
        localeReminder.add("reminder_3_hour_before");
      }
      if (remain > 1440) {
        localeReminder.add("reminder_1_day_before");
      }
      if (remain > 4320) {
        localeReminder.add("reminder_3_day_before");
      }
    }

    return WillPopScope(
        onWillPop: () {
          getDiscard();
          return null;
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Stack(children: [
                const SetImageContent(),
                Container(
                  height: 50,
                  width: 50,
                  transform: Matrix4.translationValues(
                      spaceXMD, fullHeight * 0.05, 0.0),
                  decoration: BoxDecoration(
                    color: warningBG,
                    borderRadius:
                        BorderRadius.all(Radius.circular(roundedCircle)),
                    boxShadow: [
                      BoxShadow(
                        color: darkColor.withOpacity(0.35),
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
                    color: whiteColor,
                    onPressed: () async {
                      getDiscard();
                    },
                  ),
                ),
              ]),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: spaceLG),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(roundedMD),
                  color: whiteColor,
                ),
                child: ListView(
                    padding: EdgeInsets.only(bottom: spaceJumbo),
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getSubTitleMedium(
                                    "Title".tr, darkColor, TextAlign.start),
                                getInputWarning(eventTitleMsg),
                                getInputText(75, contentTitleCtrl, false),
                              ])),
                      Container(
                        padding: EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                        child: getSubTitleMedium(
                            "Description".tr, darkColor, TextAlign.start),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                        child: getInputDesc(10000, 5, contentDescCtrl, false),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: spaceMD),
                          child: Divider(
                              thickness: 1,
                              indent: spaceLG,
                              endIndent: spaceLG)),
                      Container(
                          margin: EdgeInsets.only(left: spaceLG),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              getSubTitleMedium(
                                  "Event Tag".tr, darkColor, TextAlign.start),
                              getInputWarning(eventTagMsg),
                              const ChooseTag(),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: spaceMD),
                          child: Divider(
                              thickness: 1,
                              indent: spaceLG,
                              endIndent: spaceLG)),
                      Container(
                          padding: EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                          child: Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getSubTitleMedium("Event Reminder".tr,
                                        darkColor, TextAlign.start),
                                    Container(
                                        padding: EdgeInsets.only(left: spaceSM),
                                        child: getDropDownMain(
                                            slctReminderType, localeReminder,
                                            (String newValue) {
                                          setState(() {
                                            slctReminderType = newValue;
                                          });
                                        }, true, "reminder_")),
                                  ]),
                              SizedBox(width: spaceLG),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getSubTitleMedium("Event Location".tr,
                                      darkColor, TextAlign.start),
                                  SetLocation(locDetailCtrl: locDetailCtrl),
                                ],
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: spaceMD),
                          child: Divider(
                              thickness: 1,
                              indent: spaceLG,
                              endIndent: spaceLG)),
                      Container(
                          padding: EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getSubTitleMedium("Event Period".tr, darkColor,
                                    TextAlign.start),
                                Row(children: [
                                  getDatePicker(dateStartCtrl, () {
                                    final now = DateTime.now();

                                    DatePicker.showDateTimePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(
                                            now.year, now.month, now.day),
                                        maxTime: DateTime(
                                            now.year + 1, now.month, now.day),
                                        onConfirm: (date) {
                                      setState(() {
                                        int remain = getMinutesDifference(
                                            date, DateTime.now());
                                        getReminderBasedPeriod(remain);
                                        dateStartCtrl = date;
                                      });
                                    },
                                        currentTime: dateStartCtrl ?? now,
                                        locale: LocaleType.en);
                                  }, "Start", "datetime"),
                                  SizedBox(width: spaceSM),
                                  getDatePicker(dateEndCtrl, () {
                                    final now = DateTime.now();

                                    DatePicker.showDateTimePicker(context,
                                        showTitleActions: true,
                                        minTime: getMinEndTime(dateStartCtrl),
                                        maxTime: DateTime(
                                            now.year + 1, now.month, now.day),
                                        onConfirm: (date) {
                                      setState(() {
                                        dateEndCtrl = date;
                                      });
                                    },
                                        currentTime: dateStartCtrl ??
                                            getMinEndTime(dateStartCtrl),
                                        locale: LocaleType.en);
                                  }, "End", "datetime"),
                                ]),
                                getInputWarning(eventPeriodMsg),
                              ])),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: spaceMD),
                          child: Divider(
                              thickness: 1,
                              indent: spaceLG,
                              endIndent: spaceLG)),
                      Container(
                          padding: EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getSubTitleMedium("Attachment".tr, darkColor,
                                    TextAlign.start),
                                const SetFileAttachment()
                              ])),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: spaceMD),
                          child: Divider(
                              thickness: 1,
                              indent: spaceLG,
                              endIndent: spaceLG)),
                      Container(
                          padding: EdgeInsets.fromLTRB(spaceLG, 0, spaceLG, 0),
                          child: const GetInfoBox(
                            page: "homepage",
                            location: "add_event",
                          ))
                    ]),
              )),
              SizedBox(
                  width: fullWidth,
                  height: btnHeightMD,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isLoadPost == false) {
                        setState(() {
                          isLoadPost = true;
                        });
                        bool isValid = true;
                        bool isValidNow = true;
                        eventPeriodMsg = '';
                        eventTagMsg = '';
                        eventDescMsg = '';

                        if (dateStartCtrl == null || dateEndCtrl == null) {
                          isValid = false;
                          eventPeriodMsg = "date period must be selected".tr;
                          Get.dialog(FailedDialog(
                              text: eventPeriodMsg, type: "addevent"));
                        } else {
                          if (dateStartCtrl.isAfter(dateEndCtrl)) {
                            isValid = false;
                            eventPeriodMsg = invalidDateMsg;
                            Get.dialog(FailedDialog(
                                text: invalidDateMsg, type: "addevent"));
                          }
                        }

                        if (selectedTag == null || selectedTag.isEmpty) {
                          isValid = false;
                          eventTagMsg = "Tag must be selected".tr;
                          Get.dialog(FailedDialog(
                              text: eventTagMsg, type: "addevent"));
                        }
                        if (contentTitleCtrl.text.trim() == null ||
                            contentTitleCtrl.text.trim() == '') {
                          isValid = false;
                          eventTitleMsg = "Field can't be empty".tr;
                          Get.dialog(FailedDialog(
                              text: "Field can't be empty".tr,
                              type: "addevent"));
                        }

                        if (isValid) {
                          if (DateTime.now().isAfter(dateStartCtrl)) {
                            isValidNow = false;
                            eventPeriodMsg = invalidDateToNowMsg;
                            Get.dialog(FailedDialog(
                                text: invalidDateToNowMsg, type: "addevent"));
                          }
                          if (DateTime.now().isAfter(dateEndCtrl)) {
                            isValidNow = false;
                            eventPeriodMsg = invalidDateToNowMsg;
                            Get.dialog(FailedDialog(
                                text: invalidDateToNowMsg, type: "addevent"));
                          }
                          if (isValidNow) {
                            ContentModel content = ContentModel(
                              contentTitle: contentTitleCtrl.text.trim(),
                              contentDesc: contentDescCtrl.text.trim(),
                              contentTag: validateNullJSON(selectedTag),
                              contentLoc: getContentLocObj(
                                  locDetailCtrl.text, locCoordinateCtrl),
                              contentAttach: validateNullJSON(listAttachment),
                              contentImage: validateNull(contentAttImage),
                              reminder: slctReminderType,
                              dateStart: getDBDateFormat("date", dateStartCtrl),
                              dateEnd: getDBDateFormat("date", dateEndCtrl),
                              timeStart: getDBDateFormat(
                                  "time",
                                  dateStartCtrl.add(Duration(
                                      hours: getUTCHourOffset() * -1))),
                              timeEnd: getDBDateFormat(
                                  "time",
                                  dateEndCtrl.add(Duration(
                                      hours: getUTCHourOffset() * -1))),
                              isDraft: 0,
                            );
                            apiCommand.postContent(content).then((response) {
                              setState(() => {});
                              var status = response[0]['message'];
                              var body = response[0]['body'];

                              if (status == "success") {
                                selectedTag.clear();
                                locDetailCtrl.clear();
                                locCoordinateCtrl = null;
                                contentAttImage = null;
                                listAttachment = [];
                                Get.toNamed(CollectionRoute.bar,
                                    preventDuplicates: false);

                                Get.dialog(SuccessDialog(text: body));
                              } else {
                                if (body is! String) {
                                  if (body['content_title'] != null) {
                                    eventTitleMsg = body['content_title'][0];

                                    if (body['content_title'].length > 1) {
                                      for (String e in body['content_title']) {
                                        eventTitleMsg += e;
                                      }
                                    }
                                  }

                                  if (body['content_desc'] != null) {
                                    eventDescMsg = body['content_desc'][0];

                                    if (body['content_desc'].length > 1) {
                                      for (String e in body['content_desc']) {
                                        eventDescMsg += e;
                                      }
                                    }
                                  }
                                } else {
                                  allMsg = body;
                                }
                                Get.dialog(
                                    FailedDialog(text: body, type: "addevent"));
                              }
                            });
                          }
                        }

                        setState(() {
                          isLoadPost = false;
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(successBG),
                    ),
                    child: isLoadPost == false
                        ? Text('Publish Event'.tr,
                            style: TextStyle(fontSize: textXMD))
                        : Center(
                            child:
                                CircularProgressIndicator(color: whiteColor)),
                  ))
            ],
          ),
        ));
  }
}
