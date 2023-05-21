import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class GetHomePageEventContainer extends StatefulWidget {
  GetHomePageEventContainer({Key key, this.width, this.content, this.servc})
      : super(key: key);
  final double width;
  var content;
  var servc;

  @override
  _GetHomePageEventContainer createState() => _GetHomePageEventContainer();
}

class _GetHomePageEventContainer extends State<GetHomePageEventContainer> {
  Widget getUsername(u1, u2) {
    String username = " ";
    if (u1 != null) {
      username = u1;
    } else if (u2 != null) {
      username = u2;
    } else {
      username = "Unknown User";
    }
    return Text(username,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: greybg, fontWeight: FontWeight.w400, fontSize: textSM - 1));
  }

  Widget getProfileImage(u1, u2, i1, i2) {
    String username = " ";
    String image = null;
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
                                getUsername(widget.content.acUsername,
                                    widget.content.ucUsername),
                              ],
                            ))
                      ],
                    ),
                    getDescHeaderWidget(widget.content.contentDesc)
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  passSlug: widget.content.slugName)),
                        );
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
  var content;
  var ctx;

  GetScheduleContainer({Key key, this.width, this.content, this.ctx})
      : super(key: key);

  //Get icon based on event or task
  Widget getIcon(type, dateStart) {
    if (type == 1) {
      //Event or content
      return Icon(
        Icons.event_note_outlined,
        color: getColor(DateTime.parse(dateStart)),
        size: 38,
      );
    } else if (type == 2) {
      //Task
      return Icon(
        Icons.task,
        color: getColor(DateTime.parse(dateStart)),
        size: 38,
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.82,
      padding:
          EdgeInsets.symmetric(horizontal: paddingXSM, vertical: paddingXSM),
      margin: EdgeInsets.only(bottom: marginMT),
      transform: Matrix4.translationValues(40.0, 5.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getBgColor(DateTime.parse(content.dateStart)),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  content.contentTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    color: getColor(DateTime.parse(content.dateStart)),
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
                    color: getColor(DateTime.parse(content.dateStart)),
                    fontWeight: FontWeight.w500,
                    fontSize: textSM,
                  ),
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: getTagShow(content.contentTag, content.dateStart)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: getLocation(content.contentLoc,
                  getColor(DateTime.parse(content.dateStart))),
            )
          ])),
    );
  }
}
