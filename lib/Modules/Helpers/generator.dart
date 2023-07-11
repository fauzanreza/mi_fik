import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

getToday(String type) {
  if (type == "date") {
    return DateFormat("dd MMM yyyy").format(DateTime.now());
  } else if (type == "clock") {
    return DateFormat("hh : mm a").format(DateTime.now());
  } else if (type == "part") {
    return DateFormat("HH").format(DateTime.now());
  }
}

getShadow(String type) {
  if (type == "high") {
    return BoxShadow(
      color: shadowColor.withOpacity(0.4),
      blurRadius: 14.0,
      spreadRadius: 2.0,
      offset: const Offset(
        8.0,
        8.0,
      ),
    );
  } else if (type == "med") {
    return BoxShadow(
      color: shadowColor.withOpacity(0.35),
      blurRadius: 10.0,
      spreadRadius: 0.0,
      offset: const Offset(
        5.0,
        5.0,
      ),
    );
  }
}

getTodayCalendarHeader(DateTime val) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final content = DateTime(val.year, val.month, val.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  var tomorrow = now.add(const Duration(days: 1));
  tomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

  if (content == today) {
    return "Today".tr;
  } else if (content == yesterday) {
    return "Yesterday".tr;
  } else if (content == tomorrow) {
    return "Tommorow".tr;
  } else {
    return DateFormat("yyyy").format(val).toString();
  }
}

getColor(DateTime ds, DateTime de) {
  if (isPassedDate(ds, de)) {
    return whiteColor;
  } else {
    return primaryColor;
  }
}

getBgColor(DateTime ds, DateTime de) {
  if (isPassedDate(ds, de)) {
    return primaryColor;
  } else {
    return whiteColor;
  }
}

//Get content tag.
Widget getTagShow(tag, dateStart, dateEnd) {
  int i = 0;
  int max = 3; //Maximum tag

  if (tag != null) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: spaceSM, vertical: spaceMini + 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: getColor(
              DateTime.parse(dateStart)
                  .add(Duration(hours: getUTCHourOffset())),
              DateTime.parse(dateEnd).add(Duration(hours: getUTCHourOffset()))),
        ),
        child: Wrap(
            runSpacing: -spaceWrap,
            spacing: spaceWrap,
            children: tag.map<Widget>((content) {
              if (i < max) {
                i++;
                return Container(
                    margin: EdgeInsets.only(bottom: spaceMini),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.circle,
                                size: textSM, color: Colors.blue), //for now.
                          ),
                          TextSpan(
                            text: " ${content['tag_name']}",
                            style: TextStyle(
                                color: getBgColor(
                                    DateTime.parse(dateStart).add(
                                        Duration(hours: getUTCHourOffset())),
                                    DateTime.parse(dateEnd).add(
                                        Duration(hours: getUTCHourOffset()))),
                                fontSize: textSM),
                          ),
                        ],
                      ),
                    ));
              } else if (i == max) {
                i++;
                return Container(
                    margin: EdgeInsets.only(bottom: spaceMini),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.more,
                                size: textSM, color: Colors.blue), //for now.
                          ),
                          TextSpan(
                            text: " See ${tag.length - max} More",
                            style: TextStyle(
                                color: getBgColor(
                                    DateTime.parse(dateStart).add(
                                        Duration(hours: getUTCHourOffset())),
                                    DateTime.parse(dateEnd).add(
                                        Duration(hours: getUTCHourOffset()))),
                                fontSize: textSM),
                          ),
                        ],
                      ),
                    ));
              } else {
                return const SizedBox();
              }
            }).toList()));
  } else {
    return const SizedBox();
  }
}

getDateText(DateTime date, String type, String view) {
  if (view == "datetime") {
    if (date != null) {
      return DateFormat("dd-MM-yy HH:mm").format(date).toString();
    } else {
      return "Set Date $type";
    }
  } else if (view == "date") {
    if (date != null) {
      return DateFormat("dd-MM-yy").format(date).toString();
    } else {
      return "Set Date $type";
    }
  }
}

Widget getLocation(loc, textColor) {
  if (loc != null) {
    String location = "";
    if (loc[0]['detail'] != null) {
      location = loc[0]['detail'];
    } else {
      location = loc[1]['detail'];
    }

    return Container(
        margin: EdgeInsets.only(bottom: spaceSM),
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(Icons.location_on_outlined,
                    color: textColor, size: 18),
              ),
              TextSpan(
                  text: " ${ucFirst(location)}",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: textColor)),
            ],
          ),
        ));
  } else {
    return Container(
        margin: EdgeInsets.only(bottom: spaceLG), child: const SizedBox());
  }
}

Widget getHourChipLine(String dateStart, double width) {
  DateTime date =
      DateTime.parse(dateStart).add(Duration(hours: getUTCHourOffset()));

  getLiveText(DateTime dt) {
    if (DateFormat("HH").format(DateTime.now()) ==
            DateFormat("HH").format(dt) &&
        DateFormat("dd").format(DateTime.now()) ==
            DateFormat("dd").format(dt)) {
      return Row(children: [
        SizedBox(width: spaceXMD),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(Icons.circle, size: 14, color: warningBG),
              ),
              TextSpan(
                  text: " Just Started",
                  style: TextStyle(
                      color: warningBG,
                      fontSize: textMD,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        )
      ]);
    } else {
      return const SizedBox();
    }
  }

  return Container(
      margin: EdgeInsets.only(top: spaceSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.hour}:00',
            style: TextStyle(
              color: shadowColor,
              fontSize: textSM,
              fontWeight: FontWeight.w500,
            ),
          ),
          getLiveText(date),
          Expanded(
              child: Container(
            margin: EdgeInsets.fromLTRB(spaceXMD, spaceSM, spaceXMD, 0),
            color: primaryColor,
            height: 2,
            width: width,
          ))
        ],
      ));
}

Widget getInputWarning(String text) {
  if (text.trim() != "") {
    return Container(
        margin: EdgeInsets.symmetric(vertical: spaceMini),
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  FontAwesomeIcons.triangleExclamation,
                  size: iconSM - 2,
                  color: warningBG,
                ),
              ),
              TextSpan(
                  text: " $text",
                  style: TextStyle(color: warningBG, fontSize: textSM)),
            ],
          ),
        ));
  } else {
    return const SizedBox();
  }
}

Widget getHourText(String date, var margin, var align) {
  return Container(
      margin: margin,
      alignment: align,
      child: Text(
          getDBDateFormat("time",
              DateTime.parse(date).add(Duration(hours: getUTCHourOffset()))),
          style: TextStyle(fontSize: textSM)));
}

String getRandomString(int length) {
  var chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  return chars;
}

String getTotalArchive(event, task) {
  String ev = "Events";
  String ts = "Tasks";

  if ((event != 0) && (task == 0)) {
    return "$event ${ev.tr}";
  } else if ((event == 0) && (task != 0)) {
    return "$task ${ts.tr}";
  } else if ((event > 0) && (task > 0)) {
    return "$event ${ev.tr}, $task ${ts.tr}";
  } else {
    return "No event and task attached".tr;
  }
}

Future<void> getCurrentLocationDetails() async {
  try {
    Position currentPosition = await Geolocator.getCurrentPosition();
    double latitude = currentPosition.latitude;
    double longitude = currentPosition.longitude;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String locationName = placemark.name ?? '';
      // String thoroughfare = placemark.thoroughfare ?? '';
      // String subLocality = placemark.subLocality ?? '';
      // String locality = placemark.locality ?? '';
      // String administrativeArea = placemark.administrativeArea ?? '';
      // String country = placemark.country ?? '';

      locName = locationName;
      // print(locName);
    } else {
      Get.snackbar("Alert", "No Placemark is found",
          backgroundColor: whiteColor);
      locName = 'Invalid Location';
    }
  } catch (e) {
    return e;
  }
}

DateTime getMinEndTime(DateTime ds) {
  final now = DateTime.now();
  if (ds != null) {
    return DateTime(ds.year, ds.month, ds.day, ds.hour, ds.minute + 1);
  } else {
    return DateTime(now.year, now.month, now.day);
  }
}

int getUTCHourOffset() {
  DateTime now = DateTime.now();
  Duration offset = now.timeZoneOffset;
  return offset.inHours;
}
