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
    return TableCalendar(
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
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: warningBG),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }
}
