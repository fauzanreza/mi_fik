import 'package:intl/intl.dart';

getDBDateFormat(type, date) {
  if (type == "date" && type != null) {
    return DateFormat("yyyy-MM-dd").format(date);
  } else if (type == "time" && type != null) {
    return DateFormat("HH:mm").format(date);
  }
}
