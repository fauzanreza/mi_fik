import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Validation variable
int usernameLength = 30;
int fnameLength = 30;
int lnameLength = 30;
int passwordLength = 50;

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
  if (date != null && date != "null") {
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
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
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
    print("GPS Service is not enabled, turn on GPS location");
  }
}
