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
