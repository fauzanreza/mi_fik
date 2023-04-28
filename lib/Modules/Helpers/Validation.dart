import 'dart:convert';

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
