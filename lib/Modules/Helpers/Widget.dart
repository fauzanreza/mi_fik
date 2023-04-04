import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/Converter.dart';
import 'package:mi_fik/main.dart';

Widget getUploadDateWidget(date) {
  //Initial variable.
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final justNowHour = DateTime(now.hour);
  final justNowMinute = DateFormat("mm").format(now);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final content = DateTime(date.year, date.month, date.day);
  final contentHour = DateTime(date.hour);
  final contentMinute = DateFormat("mm").format(date);

  var result = "";

  if (content == today) {
    if (justNowHour == contentHour) {
      int diff = int.parse((justNowMinute).toString()) -
          int.parse((contentMinute).toString());
      if (diff > 10) {
        result = "$diff min ago";
      } else {
        result = "Just Now";
      }
    } else {
      result = "Today at ${DateFormat("HH:mm").format(date).toString()}";
    }
  } else if (content == yesterday) {
    result = "Yesterday at ${DateFormat("HH:mm").format(date).toString()}";
  } else {
    result = DateFormat("yyyy/MM/dd HH:mm").format(date).toString();
  }

  return Text(result,
      style: TextStyle(
        color: whitebg,
        fontWeight: FontWeight.w500,
      ));
}

Widget getViewWidget(total) {
  return RichText(
    text: TextSpan(
      children: [
        WidgetSpan(
          child: Icon(Icons.remove_red_eye, size: 14, color: whitebg),
        ),
        TextSpan(text: " $total", style: TextStyle(color: whitebg)),
      ],
    ),
  );
}

getImageHeader(url) {
  if (url.trim() != "" && url != "null") {
    return NetworkImage(url);
  } else {
    return AssetImage('assets/content/content-2.jpg');
  }
}

Widget getDescHeaderWidget(desc) {
  if (desc.trim() != "" && desc != "null") {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text(removeHtmlTags(desc),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: blackbg, fontSize: textSM)));
  } else {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text("No description provided",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: blackbg,
                fontSize: textSM,
                fontStyle: FontStyle.italic)));
  }
}

Widget getContentLoc(loc) {
  if (loc != null) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.location_on, color: primaryColor, size: iconSM),
          ),
          TextSpan(
              text: " ${loc[0]['detail']}",
              style: TextStyle(color: primaryColor, fontSize: textSM)),
        ],
      ),
    );
  } else {
    return SizedBox();
  }
}

Widget getTotalTag(tag) {
  if (tag != null) {
    int total = tag.length;

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.tag, color: primaryColor, size: iconSM),
          ),
          TextSpan(
              text: total.toString(),
              style: TextStyle(color: primaryColor, fontSize: textSM)),
        ],
      ),
    );
  } else {
    return SizedBox();
  }
}

//Get content tag.
Widget getTag(tag, height, ctx) {
  int i = 0;
  int max = 10; //Maximum tag

  if (tag != null) {
    return Wrap(
        runSpacing: -5,
        spacing: 5,
        children: tag.map<Widget>((content) {
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
                backgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
              ),
            );
          } else if (i == max) {
            i++;
            return Container(
                margin: const EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: () => showDialog<String>(
                    context: ctx,
                    builder: (BuildContext context) => AlertDialog(
                      contentPadding: EdgeInsets.all(paddingMD),
                      title: Text(
                        'All Tag',
                        style: TextStyle(color: primaryColor, fontSize: textMD),
                      ),
                      content: SizedBox(
                          width: height,
                          child: Wrap(
                              runSpacing: -5,
                              spacing: 5,
                              children: tag.map<Widget>((content) {
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
                    "See ${tag.length - max} More",
                    style: TextStyle(color: primaryColor),
                  ),
                ));
          } else {
            return const SizedBox();
          }
        }).toList());
  } else {
    return const SizedBox();
  }
}

Widget getContentHour(dateStart, dateEnd) {
  if (dateStart != null && dateEnd != null) {
    return RichText(
      text: TextSpan(
        children: [
          //Content date start & end
          WidgetSpan(
            child: Icon(Icons.access_time, size: 22, color: primaryColor),
          ),
          TextSpan(
              text:
                  " ${DateFormat("hh:mm a").format(DateTime.parse(dateStart))} - ${DateFormat("hh:mm a").format(DateTime.parse(dateEnd))} WIB",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: textMD,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}
