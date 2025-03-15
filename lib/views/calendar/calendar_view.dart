import 'dart:developer';

import 'package:final_thesis_app/app/helpers/calendar_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerStatefulWidget{
  const CalendarView({super.key});

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends ConsumerState<CalendarView>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var defaultDaysStyle = theme.textTheme.bodySmall?.copyWith(fontSize: 20);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TableCalendar(
        shouldFillViewport: true,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.twoWeeks: 'Weeks',
        },
        headerStyle: HeaderStyle(
          formatButtonTextStyle: theme.textTheme.bodySmall!,
          formatButtonDecoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: theme.colorScheme.primary
            ),
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(25.0),
          ),
          formatButtonShowsNext: false,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(25.0),
          ),
          headerPadding: EdgeInsets.all(0),
          headerMargin: EdgeInsets.fromLTRB(0, 10, 0, 15),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          log('Selected: $selectedDay; Focused: $focusedDay');
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },

        calendarBuilders: CalendarBuilders(
          // Header title
          headerTitleBuilder: (BuildContext context, DateTime day) {
            return Center(
              child: Text(
                '${getMonthName(month: day.month)} | ${day.day}-th',
                style: theme.textTheme.bodySmall,
              ),
            );
          },

          // Weekdays headers
          dowBuilder: (BuildContext context, DateTime day) {
            return Center(
              child: Text(
                getWeekdayName(weekday: day.weekday, isShort: true).toUpperCase(),
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 15),
              ),
            );
          },

          // Regular days in current month
          defaultBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            return SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      day.day.toString(),
                      style: defaultDaysStyle,
                    ),
                  ]
                )
              ),
            );
          },

          //Today day
          todayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            return SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary,width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      day.day.toString(),
                      style: defaultDaysStyle!,
                    ),
                  ]
                )
              ),
            );
          },

          // Outer months days
          outsideBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            return SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      day.day.toString(),
                      style: defaultDaysStyle!.copyWith(color: theme.colorScheme.secondary),
                    ),
                  ]
                )
              ),
            );
          },

          // Disabled days
          // disabledBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {},

          // Selected day
          selectedBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            return SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Text(
                      day.day.toString(),
                      style: defaultDaysStyle!,
                    ),
                  ]
                )
              ),
            );
          },

          // Marker for events below days
          // markerBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {},
        ),
      ),
    );
  }
}