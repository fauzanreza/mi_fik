import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
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
      color: const Color.fromARGB(255, 128, 128, 128).withOpacity(0.4),
      blurRadius: 14.0,
      spreadRadius: 2.0,
      offset: const Offset(
        8.0,
        8.0,
      ),
    );
  } else if (type == "med") {
    return BoxShadow(
      color: const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
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
    return "Today";
  } else if (content == yesterday) {
    return "Yesterday";
  } else if (content == tomorrow) {
    return "Tommorow";
  } else {
    return DateFormat("yyyy").format(val).toString();
  }
}

getColor(date) {
  if (DateFormat("HH").format(DateTime.now()) ==
          DateFormat("HH").format(date) &&
      DateFormat("dd").format(DateTime.now()) ==
          DateFormat("dd").format(date)) {
    return whitebg;
  } else {
    return primaryColor;
  }
}

getBgColor(date) {
  if (DateFormat("HH").format(DateTime.now()) ==
          DateFormat("HH").format(date) &&
      DateFormat("dd").format(DateTime.now()) ==
          DateFormat("dd").format(date)) {
    return primaryColor;
  } else {
    return whitebg;
  }
}

//Get content tag.
Widget getTagShow(tag, dateStart) {
  int i = 0;
  int max = 3; //Maximum tag

  if (tag != null) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: getColor(DateTime.parse(dateStart)),
        ),
        child: Wrap(
            runSpacing: -5,
            spacing: 5,
            children: tag.map<Widget>((content) {
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
                        text: " See ${tag.length - max} More",
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

String getDateText(DateTime date, String type, String view) {
  if (view == "datetime") {
    if (date != null) {
      return DateFormat("dd-MM-yy ").format(date).toString();
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
    var location = loc[0]['detail'];

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.location_on_outlined, color: textColor, size: 18),
          ),
          TextSpan(
              text: " $location",
              style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}

Widget getUploadDate(DateTime date) {
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
    result = DateFormat("dd/MM/yy HH:mm").format(date).toString();
  }

  return Text(result,
      style: TextStyle(
        color: whitebg,
        fontWeight: FontWeight.w500,
      ));
}

Widget getHourChipLine(String dateStart, double width) {
  DateTime date = DateTime.parse(dateStart);

  getLiveText(DateTime dt) {
    if (DateFormat("HH").format(DateTime.now()) ==
            DateFormat("HH").format(dt) &&
        DateFormat("dd").format(DateTime.now()) ==
            DateFormat("dd").format(dt)) {
      return Row(children: [
        SizedBox(width: paddingSM),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(Icons.circle, size: 14, color: dangerColor),
              ),
              TextSpan(text: " Now Live", style: TextStyle(color: dangerColor)),
            ],
          ),
        )
      ]);
    } else {
      return const SizedBox();
    }
  }

  return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.hour}:00',
            style: GoogleFonts.poppins(
              color: greybg,
              fontSize: textSM,
              fontWeight: FontWeight.w500,
            ),
          ),
          getLiveText(date),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 7.5),
            color: primaryColor,
            height: 2,
            width: width,
          ))
        ],
      ));
}

Widget getHourText(String date, var margin, var align) {
  return Container(
      margin: margin,
      alignment: align,
      child: Text(getDBDateFormat("time", DateTime.parse(date)),
          style: TextStyle(fontSize: textSM)));
}

String getRandomString(int length) {
  var chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  return chars;
}

String getTotalArchieve(event, task) {
  if ((event != 0) && (task == 0)) {
    return "$event Events";
  } else if ((event == 0) && (task != 0)) {
    return "$task Task";
  } else {
    return "$event Events, $task Task";
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
      print(locName);
    } else {
      print('No placemarks found for the current location');
      locName = 'Invalid Location';
    }
  } catch (e) {
    return e;
  }
}
