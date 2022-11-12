import 'package:flutter/material.dart';
import 'package:mi_fik/Others/leftbar.dart';
import 'package:mi_fik/Others/rightbar.dart';
import 'package:mi_fik/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: const LeftBar(),
        drawerScrimColor: primaryColor.withOpacity(0.35),
        endDrawer: RightBar(),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(
                top: fullHeight *
                    0.02), //Check this!!! make same as the other main menu page
            children: [
              Container(
                margin: EdgeInsets.zero,
                child: Row(children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.menu, size: 32, color: primaryColor),
                    tooltip: '...',
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.notifications,
                        size: 32, color: primaryColor),
                    tooltip: 'Notification',
                    onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
                  ),
                ]),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TableCalendar(
                    focusedDay: selectedDay,
                    firstDay: DateTime.utc(2022),
                    lastDay: DateTime.utc(2052),
                    weekendDays: const [DateTime.sunday],
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat _format) {
                      setState(
                        () {
                          format = _format;
                        },
                      );
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    // Day Changed
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(
                        () {
                          selectedDay = selectDay;
                          focusedDay = focusDay;
                        },
                      );
                      print(selectedDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },

                    //To style the Calendar
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: primaryColor),
                      selectedTextStyle: const TextStyle(color: Colors.white),
                      holidayTextStyle: const TextStyle(color: Colors.red),
                      weekendTextStyle: const TextStyle(color: Colors.red),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Colors.red),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                  Row(
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '06.00',
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: textSM,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 7),
                                color: primaryColor,
                                height: 2.0,
                                width: fullWidth * 0.78,
                              ),
                              SizedBox(height: fullHeight * 0.02),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: fullWidth * 0.68,
                                    height: fullHeight * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: primaryColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text(
                                                'UAS - STUDIO 4',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: textSM,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    'Lt.4 FIK',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: fullWidth * 0.02),
                                                  Text(
                                                    '10.00 AM',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 160,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 8,
                                                              height: 8,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 3),
                                                            Text(
                                                              'DE-42-E',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          8),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 8,
                                                              height: 8,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 3),
                                                            Text(
                                                              'DE 2018',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          8),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 8,
                                                              height: 8,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .yellow,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 3),
                                                            Text(
                                                              'Studio 4',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          8),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Opacity(
                                              opacity: 0.50,
                                              child: Icon(
                                                Icons.event_note_outlined,
                                                color: Colors.white,
                                                size: 38,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -10,
                                    right: -10,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: Icon(Icons.check,
                                          color: primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: fullWidth * 0.68,
                                    height: fullHeight * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text(
                                                '-',
                                                style: GoogleFonts.poppins(
                                                  color: primaryColor,
                                                  fontSize: textSM,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    'Kantin FKB',
                                                    style: GoogleFonts.poppins(
                                                      color: primaryColor,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: fullWidth * 0.02),
                                                  Text(
                                                    '12.00 PM',
                                                    style: GoogleFonts.poppins(
                                                      color: primaryColor,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: primaryColor,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 8,
                                                              height: 8,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 3),
                                                            Text(
                                                              '-',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          8),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
