import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:table_calendar/table_calendar.dart';

class ShowCalendar extends StatelessWidget {
  final DateTime active;
  final CalendarFormat format;
  final Function(CalendarFormat) setActionformat;
  final Function(DateTime, DateTime) setActionday;

  const ShowCalendar(
      {Key key,
      this.active,
      this.format,
      this.setActionformat,
      this.setActionday})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: spaceSM),
        child: TableCalendar(
          focusedDay: active,
          firstDay: DateTime.utc(2022),
          lastDay: DateTime.utc(2052),
          weekendDays: const [DateTime.sunday],
          calendarFormat: format,
          onFormatChanged: (format) {},
          startingDayOfWeek: StartingDayOfWeek.sunday,
          daysOfWeekVisible: true,

          // Day Changed
          onDaySelected: (selectedDay, focusedDay) =>
              setActionday(selectedDay, focusedDay),
          selectedDayPredicate: (DateTime date) {
            return isSameDay(active, date);
          },

          //To style the Calendar
          calendarStyle: CalendarStyle(
            tableBorder: TableBorder.all(
                color: darkColor.withOpacity(0.75),
                borderRadius: BorderRadius.all(Radius.circular(roundedMD))),
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
            selectedTextStyle: TextStyle(color: whiteColor),
            holidayTextStyle: TextStyle(color: warningBG),
            weekendTextStyle: TextStyle(color: warningBG),
          ),
          daysOfWeekHeight: iconJumbo,

          daysOfWeekStyle: DaysOfWeekStyle(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(roundedMD)),
                color: primaryLightBG),
            weekdayStyle:
                TextStyle(color: darkColor, fontWeight: FontWeight.bold),
            weekendStyle:
                TextStyle(color: warningBG, fontWeight: FontWeight.bold),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
            titleCentered: true,
          ),
        ));
  }
}
