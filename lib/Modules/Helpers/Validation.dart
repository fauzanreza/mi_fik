import 'dart:convert';

// Validation variable
int usernameLength = 30;
int passwordLength = 50;

validateNull(val) {
  if (val != null) {
    return val.toString();
  } else {
    return null;
  }
}

validateNullJSON(val) {
  if (val.length != 0) {
    return json.encode(val);
  } else {
    return null;
  }
}
