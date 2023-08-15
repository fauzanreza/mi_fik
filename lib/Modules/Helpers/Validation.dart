import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Validation variable
int usernameLength = 30;
int fnameLength = 30;
int lnameLength = 30;
int emailLength = 75;
int passwordLength = 50;

int emailMaxLength = 75;

int usernameMinLength = 6;
int emailMinLength = 10;
int passwordMinLength = 6;

validateNull(val) {
  if (val != null) {
    return val.toString();
  } else {
    return null;
  }
}

validateZero(val) {
  if (val != null) {
    return val.toInt();
  } else {
    return 0;
  }
}

validateDatetime(DateTime date) {
  if (date != null) {
    return DateFormat("yyyy-MM-dd HH:mm").format(date).toString();
  } else {
    return "null";
  }
}

validateNullJSON(val) {
  if (val.length != 0) {
    return json.encode(val);
  } else {
    return null;
  }
}

Future<bool> keyExist(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

Future checkGps(var func) async {
  bool servicestatus = false;
  bool haspermission = false;
  LocationPermission permission;

  servicestatus = await Geolocator.isLocationServiceEnabled();
  if (servicestatus) {
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Alert", 'Location permissions are denied',
            backgroundColor: whiteColor);
      } else if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Alert", 'Location permissions are permanently denied',
            backgroundColor: whiteColor);
      } else {
        haspermission = true;
      }
    } else {
      haspermission = true;
    }

    if (haspermission) {
      func;
    }
  } else {
    if (!isShownOffLocationPop) {
      Get.snackbar("Alert", 'GPS Service is not enabled, turn on GPS location',
          backgroundColor: whiteColor);
      isShownOffLocationPop = true;
    }
  }
}

bool isPassedDate(DateTime ds, DateTime de) {
  DateTime now = DateTime.now();
  return now.isAfter(ds) && now.isBefore(de);
}
