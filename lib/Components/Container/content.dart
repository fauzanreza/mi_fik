import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_detail_task.dart';

class GetScheduleContainer extends StatelessWidget {
  final double width;
  var content;
  var ctx;

  GetScheduleContainer({this.width, this.content, this.ctx});

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
                child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                content.contentTitle,
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
                              child: getTag(
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
