import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/DayEvent.dart';
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
  DateTime selectedDay = slctSchedule;
  DateTime focusedDay = slctSchedule;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: const LeftBar(),
        drawerScrimColor: primaryColor.withOpacity(0.35),
        endDrawer: const RightBar(),
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
                          slctSchedule = selectDay;
                          selectedIndex = 2;

                          //For now. need to be fixed soon!!!
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomBar()),
                          );
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
                  // Container(
                  //   margin: const EdgeInsets.only(left: 15, top: 10),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         '06.00',
                  //         style: GoogleFonts.poppins(
                  //           color: Colors.grey,
                  //           fontSize: textSM,
                  //           //fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const DayEvent()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
