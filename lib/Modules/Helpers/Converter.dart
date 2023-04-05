import 'dart:convert';

import 'package:intl/intl.dart';

Future<String> getFind(check) async {
  if (check == null || check.trim() == "") {
    return " ";
  } else {
    return check;
  }
}

getNotifSender(admin, user) {
  if (admin != null) {
    return admin;
  } else {
    return user;
  }
}

String removeHtmlTags(String htmlString) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}

getContentLocObj(detail, loc) {
  if (detail != null && loc != null) {
    var tag = [
      {'type': 'name', 'detail': detail},
      {'type': 'coordinate', 'detail': loc}
    ];
    return json.encode(tag);
  } else {
    return null;
  }
}

getItemTimeString(date) {
  //Initial variable.
  final now = DateTime.now();

  //Check this again!
  date = DateTime.parse(date);

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

  return result;
}
