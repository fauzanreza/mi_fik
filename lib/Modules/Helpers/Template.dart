import 'package:intl/intl.dart';

getDBDateFormat(type, date) {
  if (type == "date") {
    return DateFormat("yyyy-MM-dd").format(date);
  } else if (type == "time") {
    return DateFormat("HH:mm").format(date);
  }
}
