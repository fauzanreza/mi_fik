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

String ucFirst(String val) {
  String res = val[0].toUpperCase() + val.substring(1);

  return res;
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

String getMessageResponseFromObject(val, type) {
  var res = "";

  if (val is String) {
    return val;
  } else {
    if (type == "login") {
      if (val.containsKey('username') != null) {
        var usernameErr = val['username'];

        if (usernameErr != null) {
          res += "${usernameErr.join('\n')}";
        }
      }
      if (val.containsKey('password')) {
        var passErr = val['password'];
        if (passErr != null) {
          res += "${passErr.join('\n')}";
        }
      }
    } else if (type == "signout") {
      return val;
    } else if (type == "editacc") {
      if (val.containsKey('first_name') != null) {
        var fnameErr = val['first_name'];

        if (fnameErr != null) {
          res += "${fnameErr.join('\n')}";
        }
      }
      if (val.containsKey('last_name') != null) {
        var lnameErr = val['last_name'];

        if (lnameErr != null) {
          res += "${lnameErr.join('\n')}";
        }
      }
      if (val.containsKey('password')) {
        var passErr = val['password'];
        if (passErr != null) {
          res += "${passErr.join('\n')}";
        }
      }
    }

    return res;
  }
}

String getLocationName(var loc) {
  if (loc[0]['detail'] != null) {
    return " ${loc[0]['detail']}";
  } else {
    return " ${loc[1]['detail']}";
  }
}
