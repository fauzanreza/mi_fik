import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Skeletons/content_2.dart';
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/Modules/Services/Queries/ContentQueries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/DetailTask.dart';
import 'package:mi_fik/main.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({Key key}) : super(key: key);

  @override
  _MySchedulePage createState() => _MySchedulePage();
}

class _MySchedulePage extends State<MySchedulePage> {
  ContentQueriesService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ContentQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllSchedule(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ContentModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton2();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ContentModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    //Get total content in an archieve.
    getTotalArchieve(event, task) {
      if ((event != 0) && (task == 0)) {
        return "$event Events";
      } else if ((event == 0) && (task != 0)) {
        return "$task Task";
      } else {
        return "$event Events, $task Task";
      }
    }

    //Get bg color based on time start.
    getBgColor(date) {
      if (DateFormat("HH").format(DateTime.now()) ==
          DateFormat("HH").format(date)) {
        return primaryColor;
      } else {
        return whitebg;
      }
    }

    getColor(date) {
      if (DateFormat("HH").format(DateTime.now()) ==
          DateFormat("HH").format(date)) {
        return whitebg;
      } else {
        return primaryColor;
      }
    }

    //Get location name.
    Widget getLocation(loc, textColor) {
      if (loc != null) {
        //Get location name and coordinate from json.
        final jsonLoc = json.decode(loc.toString());
        var location = jsonLoc[0]['detail'];

        return RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(Icons.location_on_outlined,
                    color: textColor, size: 18),
              ),
              TextSpan(
                  text: " $location",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: textColor)),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    }

    //Get content tag.
    Widget getTag(tag, dateStart) {
      int i = 0;
      int max = 3; //Maximum tag

      if (tag != null) {
        final jsonLoc = json.decode(tag.toString());

        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: getColor(DateTime.parse(dateStart)),
            ),
            child: Wrap(
                runSpacing: -5,
                spacing: 5,
                children: jsonLoc.map<Widget>((content) {
                  if (i < max) {
                    i++;
                    return RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.circle,
                                size: textSM, color: Colors.blue), //for now.
                          ),
                          TextSpan(
                            text: " ${content['tag_name']}",
                            style: GoogleFonts.poppins(
                                color: getBgColor(DateTime.parse(dateStart)),
                                fontSize: textSM),
                          ),
                        ],
                      ),
                    );
                  } else if (i == max) {
                    i++;
                    return RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.more,
                                size: textSM, color: Colors.blue), //for now.
                          ),
                          TextSpan(
                            text: " See ${jsonLoc.length - max} More",
                            style: GoogleFonts.poppins(
                                color: getBgColor(DateTime.parse(dateStart)),
                                fontSize: textSM),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }).toList()));
      } else {
        return const SizedBox();
      }
    }

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

    if ((contents != null) && (contents.length != 0)) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: contents.map((content) {
            return SizedBox(
                width: fullWidth,
                child: IntrinsicHeight(
                    child: Stack(children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.05),
                    width: 2.5,
                    color: primaryColor,
                  ),

                  //Open content w/ full container
                  GestureDetector(
                      onTap: () {
                        if (content.dataFrom == "2") {
                          showDialog<String>(
                              context: context,
                              barrierColor: primaryColor.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                      insetPadding: EdgeInsets.all(paddingXSM),
                                      contentPadding:
                                          EdgeInsets.all(paddingXSM),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(roundedLG)),
                                      content: DetailTask(
                                        id: content.id,
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
                        width: fullWidth * 0.8,
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingXSM, vertical: paddingXSM),
                        margin: EdgeInsets.only(bottom: marginMT),
                        transform: Matrix4.translationValues(55.0, 10.0, 0.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                getBgColor(DateTime.parse(content.dateStart))),
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
                                          color: getColor(DateTime.parse(
                                              content.dateStart)),
                                          fontSize: textSM,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // getLocation(content.contentLoc),
                                      //Width doesnt enough
                                      const Spacer(),
                                      Text(
                                        DateFormat("HH : mm a").format(
                                            DateTime.parse(content.dateStart)),
                                        style: GoogleFonts.poppins(
                                          color: getColor(DateTime.parse(
                                              content.dateStart)),
                                          fontWeight: FontWeight.w500,
                                          fontSize: textSM,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: getTag(content.contentTag,
                                          content.dateStart)),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: getLocation(
                                        content.contentLoc,
                                        getColor(
                                            DateTime.parse(content.dateStart))),
                                  )
                                ])),
                      )),
                  Positioned(
                      bottom: 0,
                      right: fullWidth * 0.1,
                      child: Opacity(
                          opacity: 0.50,
                          child: getIcon(content.dataFrom, content.dateStart)))
                ])));
          }).toList());
    } else {
      return Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.asset('assets/icon/empty.png', width: fullWidth * 0.6),
              Text("No Event/Task for today, have a good rest",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: textMD))
            ],
          ));
    }
  }
}
