import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class GetHomePageEventContainer extends StatefulWidget {
  const GetHomePageEventContainer(
      {Key key, this.width, this.content, this.servc})
      : super(key: key);
  final double width;
  final dynamic content;
  final ContentCommandsService servc;

  @override
  StateGetHomePageEventContainer createState() =>
      StateGetHomePageEventContainer();
}

class StateGetHomePageEventContainer extends State<GetHomePageEventContainer> {
  Widget getUsername(u1, u2) {
    String username = " ";
    if (u1 != null) {
      username = "@$u1";
    } else if (u2 != null) {
      if (u2 == usernameKey) {
        username = "You".tr;
      } else {
        username = "@$u2";
      }
    } else {
      username = "Unknown User".tr;
    }
    return Text(username,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: shadowColor, fontWeight: FontWeight.w400, fontSize: textSM));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width * 0.82,
        margin: EdgeInsets.only(bottom: spaceXLG),
        transform: Matrix4.translationValues(40.0, 5.0, 0.0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(roundedSM)),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.35),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: const Offset(
                5.0,
                5.0,
              ),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                height: 108,
                width: widget.width,
                child: Stack(
                  children: [
                    getContentImageHeader(
                        widget.content.contentImage,
                        widget.width,
                        108,
                        true,
                        BorderRadius.only(
                            topLeft: Radius.circular(roundedSM),
                            topRight: Radius.circular(roundedSM))),
                    Padding(
                        padding: EdgeInsets.all(spaceSM),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getViewWidget(
                                  widget.content.totalViews,
                                  widget.content.acUsername,
                                  widget.content.ucUsername),
                              const Spacer(),
                              getEventStatus(widget.content.dateStart,
                                  widget.content.dateEnd)
                            ])),
                  ],
                )),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: spaceSM),
              margin: EdgeInsets.symmetric(vertical: spaceSM),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getProfileImage(
                            widget.content.acUsername,
                            widget.content.ucUsername,
                            widget.content.acImage,
                            widget.content.ucImage),
                        SizedBox(
                            width: widget.width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(ucAll(widget.content.contentTitle),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: darkColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textXMD - 1)),
                                const SizedBox(height: 1),
                                getUsername(widget.content.acUsername,
                                    widget.content.ucUsername),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: spaceXSM),
                    getDescHeaderWidget(widget.content.contentDesc, darkColor)
                  ]),
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: spaceSM),
              margin: EdgeInsets.symmetric(vertical: spaceSM),
              child: Wrap(runSpacing: spaceWrap, spacing: spaceWrap, children: [
                getContentLoc(widget.content.contentLoc),
                getTotalTag(widget.content.contentTag),
                getEventDate(widget.content.dateStart, widget.content.dateEnd)
              ]),
            ),
            Container(
                transform: Matrix4.translationValues(0.0, 5.0, 0.0),
                padding: EdgeInsets.zero,
                width: widget.width,
                height: 35,
                child: ElevatedButton(
                  onPressed: () async {
                    final connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult != ConnectivityResult.none) {
                      widget.servc
                          .postContentView(widget.content.slugName)
                          .then((response) {
                        setState(() => {});
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Get.to(() =>
                              DetailPage(passSlug: widget.content.slugName));
                        } else {
                          Get.dialog(
                              FailedDialog(text: body, type: "openevent"));
                        }
                      });
                    } else {
                      Get.to(
                          () => DetailPage(passSlug: widget.content.slugName));
                    }

                    passSlugContent = widget.content.slugName;
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    )),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(primaryColor),
                  ),
                  child: Text('Detail', style: TextStyle(fontSize: textMD)),
                )),
          ],
        ));
  }
}

class GetScheduleContainer extends StatelessWidget {
  final double width;
  final ScheduleModel content;
  final bool isConverted;

  const GetScheduleContainer(
      {Key key, this.width, this.content, this.isConverted})
      : super(key: key);

  //Get icon based on event or task
  Widget getIcon(type, dateStart, dateEnd) {
    if (type == 1) {
      //Event or content
      return FaIcon(
        FontAwesomeIcons.calendarDay,
        color: getColor(
            isConverted == true
                ? DateTime.parse(dateStart)
                : DateTime.parse(dateStart)
                    .subtract(Duration(hours: getUTCHourOffset() * -1)),
            isConverted == true
                ? DateTime.parse(dateEnd)
                : DateTime.parse(dateEnd)
                    .subtract(Duration(hours: getUTCHourOffset() * -1))),
        size: iconLG + 5,
      );
    } else if (type == 2) {
      //Task
      return Icon(
        Icons.task,
        color: getColor(
            isConverted == true
                ? DateTime.parse(dateStart)
                : DateTime.parse(dateStart)
                    .subtract(Duration(hours: getUTCHourOffset() * -1)),
            isConverted == true
                ? DateTime.parse(dateEnd)
                : DateTime.parse(dateEnd)
                    .subtract(Duration(hours: getUTCHourOffset() * -1))),
        size: iconLG + 7,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getOngoingDesc(DateTime ds, DateTime de, String desc) {
    if (isPassedDate(ds, de)) {
      return getDescHeaderWidget(desc, whiteColor);
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    //double fullWidth = MediaQuery.of(context).size.width;

    Widget getTimeEnd(DateTime dateEnd) {
      var dEnd = dateEnd;
      var now = DateTime.now();

      DateTime checkEnd = DateTime(dEnd.year, dEnd.month, dEnd.day);
      DateTime today = DateTime(now.year, now.month, now.day);

      if (checkEnd == today) {
        return Container(
            margin: EdgeInsets.only(top: spaceMini),
            padding:
                EdgeInsets.symmetric(vertical: spaceMini, horizontal: spaceSM),
            decoration: BoxDecoration(
                border: Border.all(color: whiteColor, width: 1.25),
                borderRadius: BorderRadius.all(Radius.circular(roundedSM)),
                color: warningBG),
            child: Text("${"End at".tr} ${DateFormat('HH:mm').format(dateEnd)}",
                style: TextStyle(color: whiteColor, fontSize: textSM)));
      } else {
        return const SizedBox();
      }
    }

    return Container(
      width: width * 0.82,
      padding: EdgeInsets.symmetric(horizontal: spaceSM, vertical: spaceSM),
      margin: EdgeInsets.only(bottom: spaceMD),
      transform: Matrix4.translationValues(40.0, 5.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getBgColor(
            isConverted == true
                ? DateTime.parse(content.dateStart)
                : DateTime.parse(content.dateStart)
                    .subtract(Duration(hours: getUTCHourOffset() * -1)),
            isConverted == true
                ? DateTime.parse(content.dateEnd)
                : DateTime.parse(content.dateEnd)
                    .subtract(Duration(hours: getUTCHourOffset() * -1))),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.35),
            blurRadius: 10.0,
            spreadRadius: 0.0,
            offset: const Offset(
              5.0,
              5.0,
            ),
          )
        ],
      ),
      child: Padding(
          padding: EdgeInsets.all(spaceMini),
          child: Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    ucAll(content.contentTitle),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: getColor(
                          isConverted == true
                              ? DateTime.parse(content.dateStart)
                              : DateTime.parse(content.dateStart)
                                  .add(Duration(hours: getUTCHourOffset())),
                          isConverted == true
                              ? DateTime.parse(content.dateEnd)
                              : DateTime.parse(content.dateEnd)
                                  .add(Duration(hours: getUTCHourOffset()))),
                      fontSize: textSM,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  SizedBox(width: spaceSM),
                  Text(
                    DateFormat("HH:mm").format(isConverted == true
                        ? DateTime.parse(content.dateStart)
                        : DateTime.parse(content.dateStart)
                            .add(Duration(hours: getUTCHourOffset()))),
                    style: TextStyle(
                      color: getColor(
                          isConverted == true
                              ? DateTime.parse(content.dateStart)
                              : DateTime.parse(content.dateStart)
                                  .add(Duration(hours: getUTCHourOffset())),
                          isConverted == true
                              ? DateTime.parse(content.dateEnd)
                              : DateTime.parse(content.dateEnd)
                                  .add(Duration(hours: getUTCHourOffset()))),
                      fontWeight: FontWeight.w500,
                      fontSize: textMD,
                    ),
                  ),
                ],
              ),
              getTimeEnd(isConverted == true
                  ? DateTime.parse(content.dateEnd)
                  : DateTime.parse(content.dateEnd)
                      .add(Duration(hours: getUTCHourOffset()))),
              SizedBox(height: spaceMD),
              getOngoingDesc(
                  isConverted == true
                      ? DateTime.parse(content.dateStart)
                      : DateTime.parse(content.dateStart)
                          .add(Duration(hours: getUTCHourOffset())),
                  isConverted == true
                      ? DateTime.parse(content.dateEnd)
                      : DateTime.parse(content.dateEnd)
                          .add(Duration(hours: getUTCHourOffset())),
                  content.contentDesc),
              Container(
                  margin: EdgeInsets.symmetric(vertical: spaceXMD),
                  child: getTagShow(content.contentTag, content.dateStart,
                      content.dateEnd, isConverted)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: spaceSM),
                child: getLocation(
                    content.contentLoc,
                    getColor(
                        isConverted == true
                            ? DateTime.parse(content.dateStart)
                            : DateTime.parse(content.dateStart)
                                .add(Duration(hours: getUTCHourOffset())),
                        isConverted == true
                            ? DateTime.parse(content.dateEnd)
                            : DateTime.parse(content.dateEnd)
                                .add(Duration(hours: getUTCHourOffset())))),
              ),
            ]),
            Positioned(
                bottom: 0,
                right: 0,
                child: getIcon(
                    content.dataFrom, content.dateStart, content.dateEnd))
          ])),
    );
  }
}

class GetAttachmentInput extends StatefulWidget {
  const GetAttachmentInput(
      {Key key,
      this.data,
      this.item,
      this.others,
      this.id,
      this.idx,
      this.action})
      : super(key: key);
  final dynamic data;
  final Widget item;
  final Widget others;
  final String id;
  final int idx;
  final VoidCallback action;

  @override
  StateGetAttachmentInput createState() => StateGetAttachmentInput();
}

class StateGetAttachmentInput extends State<GetAttachmentInput> {
  var attachmentNameCtrl = TextEditingController();
  var attachmentURLCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getOthers(val) {
      if (val != null) {
        return val;
      } else {
        return const SizedBox();
      }
    }

    Widget getExpansion(val) {
      if (val != null) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: spaceXMD),
            child: getSubTitleMedium(
                "Attachment Type : ${ucFirst(getSeparatedAfter("_", widget.data['attach_type']))}",
                darkColor,
                TextAlign.start));
      } else {
        return ExpansionTile(
            childrenPadding:
                EdgeInsets.fromLTRB(spaceXMD, 0, spaceXMD, spaceXMD),
            initiallyExpanded: false,
            trailing: Icon(Icons.remove_red_eye_outlined, color: darkColor),
            iconColor: null,
            textColor: whiteColor,
            collapsedTextColor: primaryColor,
            leading: null,
            expandedCrossAxisAlignment: CrossAxisAlignment.end,
            expandedAlignment: Alignment.topLeft,
            tilePadding: EdgeInsets.zero,
            title: Padding(
                padding: EdgeInsets.symmetric(vertical: spaceXMD),
                child: getSubTitleMedium(
                    "Attachment Type : ${ucFirst(getSeparatedAfter("_", widget.data['attach_type']))}",
                    darkColor,
                    TextAlign.start)),
            children: [widget.item]);
      }
    }

    return Container(
      width: fullWidth * 0.9,
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(bottom: spaceLG),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.35),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: const Offset(
                5.0,
                5.0,
              ),
            )
          ],
          color: whiteColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(spaceLG),
              bottomRight: Radius.circular(spaceLG))),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(spaceXMD, 0, spaceXMD, spaceXMD),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 4, color: successBG),
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            getExpansion(widget.others),
            getSubTitleMedium("Attachment Name".tr, darkColor, TextAlign.start),
            getInputTextAtt(75, widget.id, 'attach_name'),
            getOthers(widget.others),
            Row(
              children: [
                Ink(
                  padding: EdgeInsets.zero,
                  decoration: ShapeDecoration(
                    color: primaryColor,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: warningBG,
                    onPressed: widget.action,
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
