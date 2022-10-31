import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Database.dart';
import 'package:mi_fik/DB/Model/Content.dart';
import 'package:mi_fik/DB/Services/ContentServices.dart';
import 'package:mi_fik/Home/Detail/Attach.dart';
import 'package:mi_fik/Home/Detail/Location.dart';
import 'package:mi_fik/Home/Detail/Save.dart';
import 'package:mi_fik/main.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.passIdContent}) : super(key: key);
  final int passIdContent;

  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  ContentService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ContentService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getContent(),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ContentModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    DateTime contentDateStart = DateTime.now();
    DateTime contentDateEnd = DateTime.now();

    //Convert date.
    getContentDate(dateStart, dateEnd) {
      //Initial variable.
      var monthStart = DateFormat("MM").format(dateStart).toString();
      var dayStart = DateFormat("dd").format(dateStart).toString();
      var yearStart = DateFormat("yyyy").format(dateStart).toString();
      var monthEnd = DateFormat("MM").format(dateEnd).toString();
      var dayEnd = DateFormat("dd").format(dateEnd).toString();
      var yearEnd = DateFormat("yyyy").format(dateEnd).toString();
      var result = "";

      if (yearStart == yearEnd) {
        if (monthStart == monthEnd) {
          if (dayStart == dayEnd) {
            result =
                "$dayStart ${DateFormat("MMM").format(dateStart)} $yearStart";
          } else {
            result =
                "$dayStart-$dayEnd ${DateFormat("MMM").format(dateStart)} $yearStart";
          }
        } else {
          result =
              "$dayStart  ${DateFormat("MMM").format(dateStart)}-$dayEnd ${DateFormat("MMM").format(dateEnd)} $yearStart";
        }
      } else {
        result =
            "$dayStart  ${DateFormat("MMM").format(dateStart)} $yearStart-$dayEnd ${DateFormat("MMM").format(dateEnd)} $yearEnd";
      }

      return TextSpan(
          text: result,
          style: TextStyle(
              color: primaryColor,
              fontSize: textMD,
              fontWeight: FontWeight.w500));
    }

    //Get location name.
    Widget getLocation(loc, id) {
      if (loc != null) {
        return LocationButton(passLocation: loc.toString(), passId: id);
      } else {
        return const SizedBox();
      }
    }

    //Get attachment file or link.
    Widget getAttach(attach) {
      if (attach != null) {
        return AttachButton(passAttach: attach.toString());
      } else {
        return const SizedBox();
      }
    }

    //Get content subtitle.
    Widget getSubtitle(sub) {
      if (sub != null) {
        return Text(
          sub,
          style: TextStyle(fontSize: textSM, color: blackbg),
        );
      } else {
        return const SizedBox();
      }
    }

    //Get content tag.
    Widget getTag(tag, height) {
      int i = 0;
      int max = 10; //Maximum tag

      if (tag != null) {
        final jsonLoc = json.decode(tag.toString());

        return Wrap(
            runSpacing: -5,
            spacing: 5,
            children: jsonLoc.map<Widget>((content) {
              if (i < max) {
                i++;
                return ElevatedButton.icon(
                  onPressed: () {
                    // Respond to button press
                  },
                  icon: Icon(
                    Icons.circle,
                    size: textSM,
                    color: Colors.green,
                  ),
                  label: Text(content['tag_name'],
                      style: TextStyle(fontSize: textXSM)),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundedLG2),
                    )),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(primaryColor),
                  ),
                );
              } else if (i == max) {
                i++;
                return Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          contentPadding: EdgeInsets.all(paddingMD),
                          title: Text(
                            'All Tag',
                            style: TextStyle(
                                color: primaryColor, fontSize: textMD),
                          ),
                          content: Container(
                              width: height,
                              child: Wrap(
                                  runSpacing: -5,
                                  spacing: 5,
                                  children: jsonLoc.map<Widget>((content) {
                                    return ElevatedButton.icon(
                                      onPressed: () {
                                        // Respond to button press
                                      },
                                      icon: Icon(
                                        Icons.circle,
                                        size: textSM,
                                        color: Colors.green,
                                      ),
                                      label: Text(content['tag_name'],
                                          style: TextStyle(fontSize: textXSM)),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(roundedLG2),
                                        )),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                primaryColor),
                                      ),
                                    );
                                  }).toList())),
                        ),
                      ),
                      child: Text(
                        "See ${jsonLoc.length - max} More",
                        style: TextStyle(color: primaryColor),
                      ),
                    ));
              } else {
                return SizedBox();
              }
            }).toList());
      } else {
        return const SizedBox();
      }
    }

    return Scaffold(
      body: Stack(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              barrierColor: primaryColor.withOpacity(0.5),
              builder: (BuildContext context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  elevation: 0, //Remove shadow.
                  backgroundColor: Colors.transparent,
                  content: Container(
                    height: fullHeight * 0.45,
                    width: fullWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/content/content-2.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(roundedLG2),
                    ),
                  )),
            ),
            child: Container(
              height: fullHeight * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/content/content-2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, fullHeight * 0.03, 0.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: iconLG),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: fullHeight * 0.28),
            height: fullHeight * 0.8,
            width: fullWidth,
            padding: EdgeInsets.only(top: paddingMD),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(roundedLG2),
              color: Colors.white,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: iconLG,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                  "https://sci.telkomuniversity.ac.id/wp-content/uploads/2022/02/13.jpg")), //For now.
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contents[0].contentTitle,
                                style: TextStyle(
                                    fontSize: textMD,
                                    fontWeight: FontWeight.bold)),
                            //Check this...
                            getSubtitle(contents[0].contentSubtitle),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView(padding: EdgeInsets.zero, children: [
                    //Content Description.
                    Container(
                        margin: EdgeInsets.only(
                            top: marginMT, left: marginMD, right: marginMD),
                        child: Text(contents[0].contentDesc,
                            style:
                                TextStyle(color: blackbg, fontSize: textSM))),
                    //Attached file or link.
                    getAttach(contents[0].contentAttach),
                    //Tag holder.
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: marginMT, horizontal: marginMD),
                      child: getTag(contents[0].contentTag, fullHeight),
                    ),
                  ])),
                  Container(
                      margin: EdgeInsets.only(
                          left: marginMD, right: marginMD, bottom: marginMD),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getLocation(contents[0].contentLoc,
                                    int.parse(contents[0].id)),
                                const Spacer(),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.calendar_month,
                                            size: 22, color: primaryColor),
                                      ),
                                      getContentDate(
                                          contentDateStart, contentDateEnd)
                                    ],
                                  ),
                                )
                              ]),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.access_time,
                                      size: 22, color: primaryColor),
                                ),
                                TextSpan(
                                    text:
                                        " ${DateFormat("HH:mm a").format(contentDateStart).toString()} - ${DateFormat("HH:mm a").format(contentDateEnd).toString()} WIB",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: textMD,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )
                        ],
                      )),

                  //Save content to archieve.
                  SaveButton(passId: int.parse(contents[0].id))
                ]),
          )
        ],
      ),
    );
  }
}
