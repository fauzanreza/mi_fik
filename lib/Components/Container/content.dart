import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_detail_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class GetHomePageEventContainer extends StatelessWidget {
  final double width;
  var content;

  GetHomePageEventContainer({Key key, this.width, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width * 0.82,
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
              width: width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: getImageHeader(content.contentImage),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.darken),
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                getViewWidget(content.totalViews),
                getPeriodDateWidget(content.dateStart, content.dateEnd),
                const Spacer(),
                getUploadDateWidget(DateTime.parse(content.createdAt))
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: iconLG,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                  "https://sci.telkomuniversity.ac.id/wp-content/uploads/2022/02/13.jpg")), //For now.
                        ),
                        SizedBox(
                            width: width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(content.contentTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: blackbg,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textMD - 1)),
                                Text("username",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: greybg,
                                        fontWeight: FontWeight.w400,
                                        fontSize: textSM - 1)),
                              ],
                            ))
                      ],
                    ),
                    getDescHeaderWidget(content.contentDesc)
                  ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(runSpacing: -5, spacing: 5, children: [
                getContentLoc(content.contentLoc),
                getTotalTag(content.contentTag)
              ]),
            ),

            //Open content w/ button.
            Container(
                transform: Matrix4.translationValues(0.0, 5.0, 0.0),
                padding: EdgeInsets.zero,
                width: width,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(passSlug: content.slugName)),
                    );

                    passSlugContent = content.slugName;
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
    if (type == "1") {
      //Event or content
      return Icon(
        Icons.event_note_outlined,
        color: getColor(DateTime.parse(dateStart)),
        size: 38,
      );
    } else if (type == "2") {
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
    return SizedBox(
        width: width,
        child: IntrinsicHeight(
            child: Stack(children: [
          GestureDetector(
              onTap: () {
                if (content.dataFrom == "2") {
                  showDialog<String>(
                      context: context,
                      barrierColor: primaryColor.withOpacity(0.5),
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                              insetPadding: EdgeInsets.all(paddingXSM),
                              contentPadding: EdgeInsets.all(paddingXSM),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(roundedLG)),
                              content: DetailTask(
                                id: 2.toString(),
                                taskTitlePass: content.contentTitle,
                                taskDescPass: content.contentDesc,
                                taskDateStartPass: content.dateStart,
                                taskDateEndPass: content.dateEnd,
                              ));
                        });
                      });
                } else {
                  return print("tes");
                }
              },
              child: Container(
                width: width * 0.8,
                padding: EdgeInsets.symmetric(
                    horizontal: paddingXSM, vertical: paddingXSM),
                margin: EdgeInsets.only(bottom: marginMT),
                transform: Matrix4.translationValues(55.0, 10.0, 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getBgColor(DateTime.parse(content.dateStart)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 128, 128, 128)
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
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                content.contentTitle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  color: getColor(
                                      DateTime.parse(content.dateStart)),
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
                                  color: getColor(
                                      DateTime.parse(content.dateStart)),
                                  fontWeight: FontWeight.w500,
                                  fontSize: textSM,
                                ),
                              ),
                            ],
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              child: getTagShow(
                                  content.contentTag, content.dateStart)),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: getLocation(content.contentLoc,
                                getColor(DateTime.parse(content.dateStart))),
                          )
                        ])),
              )),
          Positioned(
              bottom: 0,
              right: width * 0.1,
              child: Opacity(
                  opacity: 0.50,
                  child: getIcon(content.dataFrom, content.dateStart)))
        ])));
  }
}
