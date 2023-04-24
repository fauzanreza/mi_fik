import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
