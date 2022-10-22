import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Database.dart';
import 'package:mi_fik/DB/Model/Content_M.dart';
import 'package:mi_fik/main.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({Key key}) : super(key: key);

  @override
  _MySchedulePage createState() => _MySchedulePage();
}

class _MySchedulePage extends State<MySchedulePage> {
  //Initial variable
  var db = Mysql();
  final List<ContentModel> _contentList = <ContentModel>[];

  //Controller
  Future getContent() async {
    db.getConnection().then((conn) {
      String sql =
          "SELECT archieve_relation.id, content_title, content_desc, content_tag, content_loc, content_date_start, content_date_end, archieve_relation.created_at FROM archieve_relation JOIN content ON archieve_relation.content_id = content.id WHERE archieve_relation.user_id = 1 AND date(content_date_start) = '${DateFormat("yyyy-MM-dd").format(slctSchedule)}' ORDER BY content.content_date_start DESC";
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            //Mapping
            var contentModels = ContentModel();

            contentModels.id = row['id'];
            contentModels.contentTitle = row['content_title'];
            contentModels.contentTag = row['content_tag'];
            contentModels.contentLoc = row['content_loc'];
            contentModels.dateStart = row['content_date_start'];
            contentModels.dateEnd = row['content_date_end'];
            contentModels.contentDesc = row['content_desc'].toString();
            contentModels.createdAt = row['created_at'];

            _contentList.add(contentModels);
          });
        }
      });
      conn.close();
    });
  }

  //Get total content in an archieve.
  getTotalArchieve(event, task) {
    if ((event != 0) && (task == 0)) {
      return "${event} Events";
    } else if ((event == 0) && (task != 0)) {
      return "${task} Task";
    } else {
      return "${event} Events, ${task} Task";
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
              child:
                  Icon(Icons.location_on_outlined, color: textColor, size: 18),
            ),
            TextSpan(
                text: " ${location}",
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
            color: getColor(dateStart),
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
                              color: getBgColor(dateStart), fontSize: textSM),
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
                              color: getBgColor(dateStart), fontSize: textSM),
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

  @override
  void initState() {
    super.initState();
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Column(
        children: _contentList.map((content) {
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
                onTap: () {},
                child: Container(
                  width: fullWidth * 0.8,
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingXSM, vertical: paddingXSM),
                  margin: EdgeInsets.only(top: marginMT),
                  transform: Matrix4.translationValues(55.0, 5.0, 0.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: getBgColor(content.dateStart)),
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
                                    color: getColor(content.dateStart),
                                    fontSize: textSM,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // getLocation(content.contentLoc),
                                //Width doesnt enough
                                const Spacer(),
                                Text(
                                  DateFormat("HH : mm a")
                                      .format(content.dateStart),
                                  style: GoogleFonts.poppins(
                                    color: getColor(content.dateStart),
                                    fontWeight: FontWeight.w500,
                                    fontSize: textSM,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: getTag(
                                    content.contentTag, content.dateStart)),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: getLocation(content.contentLoc,
                                  getColor(content.dateStart)),
                            )
                          ])),
                )),
            Positioned(
                bottom: 0,
                right: fullWidth * 0.1,
                child: Opacity(
                  opacity: 0.50,
                  child: Icon(
                    Icons.event_note_outlined,
                    color: getColor(content.dateStart),
                    size: 38,
                  ),
                ))
          ])));
    }).toList());
  }
}
