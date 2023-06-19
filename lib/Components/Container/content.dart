import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
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
  final content;
  final servc;

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
      username = "@$u2";
    } else {
      username = "Unknown User".tr;
    }
    return Text(username,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: greybg, fontWeight: FontWeight.w400, fontSize: textSM - 1));
  }

  Widget getProfileImage(u1, u2, i1, i2) {
    String image;
    if (u1 != null) {
      if (i1 != null) {
        image = i1;
      } else {
        image = null;
      }
    } else if (u2 != null) {
      if (i2 != null) {
        image = i2;
      } else {
        image = null;
      }
    } else {
      image = null;
    }
    return getProfileImageContent(image);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading;

    return Container(
        width: widget.width * 0.82,
        margin: EdgeInsets.only(bottom: marginMD),
        transform: Matrix4.translationValues(40.0, 5.0, 0.0),
        decoration: BoxDecoration(
          color: whitebg,
          borderRadius: BorderRadius.all(roundedMd),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
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
            Container(
              height: 108.0,
              width: widget.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: getImageHeader(widget.content.contentImage),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.darken),
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                getViewWidget(widget.content.totalViews),
                getPeriodDateWidget(
                    widget.content.dateStart, widget.content.dateEnd),
                const Spacer(),
                getUploadDateWidget(DateTime.parse(widget.content.createdAt))
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                Text(widget.content.contentTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: blackbg,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textMD - 1)),
                                const SizedBox(height: 1),
                                getUsername(widget.content.acUsername,
                                    widget.content.ucUsername),
                              ],
                            ))
                      ],
                    ),
                    getDescHeaderWidget(widget.content.contentDesc, blackbg)
                  ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(runSpacing: -5, spacing: 5, children: [
                getContentLoc(widget.content.contentLoc),
                getTotalTag(widget.content.contentTag)
              ]),
            ),

            //Open content w/ button.
            Container(
                transform: Matrix4.translationValues(0.0, 5.0, 0.0),
                padding: EdgeInsets.zero,
                width: widget.width,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    widget.servc
                        .postContentView(widget.content.slugName)
                        .then((response) {
                      setState(() => isLoading = false);
                      var status = response[0]['message'];
                      var body = response[0]['body'];

                      if (status == "success") {
                        Get.to(() =>
                            DetailPage(passSlug: widget.content.slugName));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                FailedDialog(text: body, type: "openevent"));
                      }
                    });

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
                  child: const Text('Detail'),
                )),
          ],
        ));
  }
}

class GetScheduleContainer extends StatelessWidget {
  final double width;
  final content;

  const GetScheduleContainer({Key key, this.width, this.content})
      : super(key: key);

  //Get icon based on event or task
  Widget getIcon(type, dateStart, dateEnd) {
    if (type == 1) {
      //Event or content
      return FaIcon(
        FontAwesomeIcons.calendarDay,
        color: getColor(DateTime.parse(dateStart), DateTime.parse(dateEnd)),
        size: iconLG + 5,
      );
    } else if (type == 2) {
      //Task
      return Icon(
        Icons.task,
        color: getColor(DateTime.parse(dateStart), DateTime.parse(dateEnd)),
        size: iconLG + 7,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getOngoingDesc(DateTime ds, DateTime de, String desc) {
    if (isPassedDate(ds, de)) {
      return getDescHeaderWidget(desc, whitebg);
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    //double fullWidth = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.82,
      padding:
          EdgeInsets.symmetric(horizontal: paddingXSM, vertical: paddingXSM),
      margin: EdgeInsets.only(bottom: marginMT),
      transform: Matrix4.translationValues(40.0, 5.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getBgColor(
            DateTime.parse(content.dateStart), DateTime.parse(content.dateEnd)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
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
          padding: const EdgeInsets.all(4),
          child: Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    content.contentTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      color: getColor(DateTime.parse(content.dateStart),
                          DateTime.parse(content.dateEnd)),
                      fontSize: textSM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // getLocation(content.contentLoc),
                  //Width doesnt enough
                  const Spacer(),
                  Text(
                    DateFormat("HH : mm a")
                        .format(DateTime.parse(content.dateStart)),
                    style: GoogleFonts.poppins(
                      color: getColor(DateTime.parse(content.dateStart),
                          DateTime.parse(content.dateEnd)),
                      fontWeight: FontWeight.w500,
                      fontSize: textSM,
                    ),
                  ),
                ],
              ),
              getOngoingDesc(DateTime.parse(content.dateStart),
                  DateTime.parse(content.dateEnd), content.contentDesc),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: getTagShow(
                      content.contentTag, content.dateStart, content.dateEnd)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: getLocation(
                    content.contentLoc,
                    getColor(DateTime.parse(content.dateStart),
                        DateTime.parse(content.dateEnd))),
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

class GetAttachmentContainer extends StatefulWidget {
  const GetAttachmentContainer(
      {Key key,
      this.data,
      this.item,
      this.others,
      this.id,
      this.idx,
      this.action})
      : super(key: key);
  final data;
  final item;
  final others;
  final String id;
  final int idx;
  final action;

  @override
  StateGetAttachmentContainer createState() => StateGetAttachmentContainer();
}

class StateGetAttachmentContainer extends State<GetAttachmentContainer> {
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
            padding: EdgeInsets.symmetric(vertical: paddingSM),
            child: getSubTitleMedium(
                "Attachment Type : ${ucFirst(getSeparatedAfter("_", widget.data['attach_type']))}",
                blackbg,
                TextAlign.start));
      } else {
        return ExpansionTile(
            childrenPadding: EdgeInsets.only(
                left: paddingSM, bottom: paddingSM, right: paddingSM),
            initiallyExpanded: false,
            trailing: Icon(Icons.remove_red_eye_outlined, color: blackbg),
            iconColor: null,
            textColor: whitebg,
            collapsedTextColor: primaryColor,
            leading: null,
            expandedCrossAxisAlignment: CrossAxisAlignment.end,
            expandedAlignment: Alignment.topLeft,
            tilePadding: EdgeInsets.zero,
            title: Padding(
                padding: EdgeInsets.symmetric(vertical: paddingSM),
                child: getSubTitleMedium(
                    "Attachment Type : ${ucFirst(getSeparatedAfter("_", widget.data['attach_type']))}",
                    blackbg,
                    TextAlign.start)),
            children: [widget.item]);
      }
    }

    return Container(
      width: fullWidth * 0.9,
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(bottom: paddingMD),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: const Offset(
                5.0,
                5.0,
              ),
            )
          ],
          color: whitebg,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(paddingMD),
              bottomRight: Radius.circular(paddingMD))),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(paddingSM, 0, paddingSM, paddingSM),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 4, color: successbg),
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            getExpansion(widget.others),
            getSubTitleMedium("Attachment Name".tr, blackbg, TextAlign.start),
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
                    color: dangerColor,
                    onPressed: widget.action,
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
