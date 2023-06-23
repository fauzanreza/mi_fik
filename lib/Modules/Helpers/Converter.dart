import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Future<String> getFind(check) async {
  if (check == null || check.trim() == "") {
    return " ";
  } else {
    return check;
  }
}

String getSeparatedAfter(String divider, String value) {
  List<String> res = value.split(divider);
  return res[1];
}

String ucFirst(String val) {
  String res = "";
  if (val != null) {
    res = val[0].toUpperCase() + val.substring(1);
  }
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

getBoolByInt(int val) {
  if (val == 1) {
    return true;
  } else {
    return false;
  }
}

getIntByBool(bool val) {
  if (val == true) {
    return 1;
  } else {
    return 0;
  }
}

String getLocalConvertedDate(String date) {
  DateTime now = DateTime.now();
  Duration timeZoneOffset = now.timeZoneOffset;
  DateTime localDateTime = DateTime.parse(date).add(timeZoneOffset);

  return DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
}

getItemTimeString(date) {
  if (date != null) {
    //Initial variable.
    final now = DateTime.now();

    //Check this again!
    date = DateTime.parse(getLocalConvertedDate(date));

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
  } else {
    return "-";
  }
}

String getWhereDateFilter(DateTime ds, DateTime de) {
  if (ds != null && de != null) {
    return "${DateFormat("yyyy-MM-dd").format(ds)}_${DateFormat("yyyy-MM-dd").format(de)}";
  } else {
    return "all";
  }
}

String getFindFilter(String check) {
  if (check == null || check.trim() == '') {
    return " ";
  } else {
    return check;
  }
}

String getTagFilterContent(List<dynamic> tag) {
  if (tag.isEmpty) {
    return "all";
  } else {
    String res = "";
    int countTag = tag.length;
    int i = 1;

    for (var e in tag) {
      if (i != countTag) {
        res += "${e['slug_name']},";
      } else {
        res += e['slug_name'];
      }
      i++;
    }

    return res;
  }
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
    } else if (type == "addarchive") {
      if (val.containsKey('archive_name') != null) {
        var anameErr = val['archive_name'];

        if (anameErr != null) {
          res += "${anameErr.join('\n')}";
        }
      }
      if (val.containsKey('archive_desc') != null) {
        var adescErr = val['archive_desc'];

        if (adescErr != null) {
          res += "${adescErr.join('\n')}";
        }
      }
    } else if (type == "addtask") {
      if (val.containsKey('task_title') != null) {
        var ttitleErr = val['task_title'];

        if (ttitleErr != null) {
          res += "${ttitleErr.join('\n')}";
        }
      }
      if (val.containsKey('task_desc') != null) {
        var tdescErr = val['task_desc'];

        if (tdescErr != null) {
          res += "${tdescErr.join('\n')}";
        }
      }
      if (val.containsKey('task_date_start')) {
        var tdsErr = val['task_date_start'];
        if (tdsErr != null) {
          res += "${tdsErr.join('\n')}";
        }
      }
      if (val.containsKey('task_date_end')) {
        var tdeErr = val['task_date_end'];
        if (tdeErr != null) {
          res += "${tdeErr.join('\n')}";
        }
      }
      if (val.containsKey('task_reminder')) {
        var remindErr = val['task_reminder'];
        if (remindErr != null) {
          res += "${remindErr.join('\n')}";
        }
      }
    } else if (type == "faq") {
      if (val.containsKey('question_body')) {
        var qbody = val['question_body'];
        if (qbody != null) {
          res += "${qbody.join('\n')}";
        }
      }
      if (val.containsKey('question_type')) {
        var qtype = val['question_type'];
        if (qtype != null) {
          res += "${qtype.join('\n')}";
        }
      }
    } else if (type == "regis") {
      if (val.containsKey('email')) {
        var email = val['email'];
        if (email != null) {
          res += "${email.join('\n')}";
        }
      }
      if (val.containsKey('username')) {
        var username = val['question_type'];
        if (username != null) {
          res += "${username.join('\n')}";
        }
      }
    }

    return res;
  }
}

String getLocationName(var loc) {
  if (loc[0]['detail'] != null) {
    return " ${ucFirst(loc[0]['detail'])}";
  } else {
    return " ${loc[1]['detail']}";
  }
}

Widget getImageProfileContent(adminUname, userUname, adminImg, userImg) {
  Widget url;
  if (adminUname != null) {
    if (adminImg != null) {
      url = Image.network(adminImg.toString());
    } else {
      url = Image.asset("assets/icon/default_lecturer.png");
    }
  } else {
    if (userImg != null) {
      url = Image.network(adminImg.toString());
    } else {
      url = Image.asset("assets/icon/default_lecturer.png");
    }
  }
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    width: iconXL,
    child: ClipRRect(borderRadius: roundedImage, child: url), //For now.
  );
}
