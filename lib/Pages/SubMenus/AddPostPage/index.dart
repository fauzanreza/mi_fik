import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
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

import 'package:mi_fik/Modules/Variables/dummy.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/Usecases/set_attachment.dart';
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
  final locDetailCtrl = TextEditingController();
  DateTime dateStartCtrl;
  DateTime dateEndCtrl;

  @override
  void initState() {
    super.initState();
    apiCommand = ContentCommandsService();
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
    bool isLoading = false;

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
                    insetPadding: EdgeInsets.all(paddingSM),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: paddingMD, vertical: paddingMD * 1.5),
                    content: SizedBox(
                        height: 120,
                        width: fullWidth,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        backgroundColor:
                                            dangerColor.withOpacity(0.8),
                                        padding:
                                            EdgeInsets.all(paddingMD * 0.8)),
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
                                        color: whitebg,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding:
                                            EdgeInsets.all(paddingMD * 0.8)),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "Cancel".tr,
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
        Get.back();
      }
    }

    return WillPopScope(
        onWillPop: () {
          getDiscard();
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Stack(children: [
                const SetImageContent(),
                Container(
                  transform: Matrix4.translationValues(
                      fullWidth * 0.03, fullHeight * 0.05, 0.0),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 67, 67, 67)
                            .withOpacity(0.3),
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
                      getDiscard();
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
                child: ListView(
                    padding: EdgeInsets.only(bottom: paddingLg),
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: getSubTitleMedium(
                            "Title".tr, blackbg, TextAlign.start),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: getInputText(75, contentTitleCtrl, false),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: getSubTitleMedium(
                            "Description".tr, blackbg, TextAlign.start),
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
                              Text("Event Tag".tr,
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
                          padding: EdgeInsets.fromLTRB(20, paddingMD, 20, 0),
                          child: Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Event Reminder".tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          color: blackbg,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    Container(
                                        padding:
                                            EdgeInsets.only(left: paddingXSM),
                                        child: getDropDownMain(
                                            slctReminderType, reminderTypeOpt,
                                            (String newValue) {
                                          setState(() {
                                            slctReminderType = newValue;
                                          });
                                        }, true, "reminder_")),
                                  ]),
                              SizedBox(width: paddingMD),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Event Location".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: blackbg,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  SetLocation(locDetailCtrl: locDetailCtrl),
                                ],
                              )
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, paddingMD, 20, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Event Period".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      color: blackbg,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Row(children: [
                                  getDatePicker(dateStartCtrl, () {
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
                                  }, "Start", "datetime"),
                                  const Spacer(),
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
                                        currentTime:
                                            getMinEndTime(dateStartCtrl),
                                        locale: LocaleType.en);
                                  }, "End", "datetime"),
                                ])
                              ])),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, paddingMD, 20, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Event Attachment".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      color: blackbg,
                                      fontWeight: FontWeight.w500,
                                    )),
                                const SetFileAttachment()
                              ])),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, paddingMD, 20, 0),
                          child: GetInfoBox(
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
                      if (dateStartCtrl != null || dateEndCtrl != null) {
                        ContentModel content = ContentModel(
                          userId: passIdUser,
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
                          timeStart: getDBDateFormat("time", dateStartCtrl),
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
                                selectedTag.clear();
                                locDetailCtrl.clear();
                                locCoordinateCtrl = null;
                                contentAttImage = null;
                                listAttachment = [];
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
                                            text: body, type: "addevent"));
                              }
                            });
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => FailedDialog(
                                    text:
                                        "Create event failed, field can't be empty",
                                    type: "addevent"));
                          }
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => FailedDialog(
                                  text:
                                      "Create event failed, tag must be selected",
                                  type: "addevent"));
                        }
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => FailedDialog(
                                text:
                                    "Create event failed, date period must be selected",
                                type: "addevent"));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(successbg),
                    ),
                    child: Text('Save Event'.tr),
                  ))
            ],
          ),
        ));
  }
}
