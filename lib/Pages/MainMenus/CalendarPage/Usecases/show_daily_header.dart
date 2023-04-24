import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getDailyHeader(DateTime selectedDay) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          children: [
            Text(
              DateFormat("EEE").format(selectedDay),
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: textMD,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat("d").format(selectedDay),
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: textLG,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: textLG,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '3 events and 3 tasks',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: textSM,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
