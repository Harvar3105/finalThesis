import 'dart:developer';

import 'package:final_thesis_app/app/helpers/calendar_parser.dart';
import 'package:final_thesis_app/presentation/view_models/calendar/calendar_view_model.dart';
import 'package:final_thesis_app/presentation/views/calendar/day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/domain/event.dart';
import '../../../data/domain/user.dart';

class CalendarView extends ConsumerStatefulWidget{
  const CalendarView({super.key, this.user, this.isProfileView = false});
  final User? user;
  final bool isProfileView;

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends ConsumerState<CalendarView>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showDayView = false;

  dayViewCallBack() {
    setState(() {
      _showDayView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var defaultDaysStyle = theme.textTheme.bodySmall?.copyWith(fontSize: 20);
    final eventsAsync = ref.watch(CalendarViewModelProvider(user: widget.user));

    return eventsAsync.when(
      data: (events) {
        Widget toShow;
        if (_showDayView) {
          if (_selectedDay != null) {
            toShow = DayViewCalendar(selectedDay: _selectedDay, changeView: dayViewCallBack, user: widget.user, isProfileView: widget.isProfileView,);
          } else {
            toShow = DayViewCalendar(changeView: dayViewCallBack, user: widget.user, isProfileView: widget.isProfileView,);
          }
        } else {
          toShow = _buildCalendar(events, theme, defaultDaysStyle!);
        }
        return toShow;
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  List<Event> _getEventsForDay(DateTime day, List<Event> events) {
    return events.where((event) {
      return isSameDay(event.start, day) || isSameDay(event.end, day);
    }).toList();
  }

  Widget _buildCalendar(List<Event>? events, ThemeData theme, TextStyle defaultDaysStyle) {
    dynamic loaderFunc = (day) => [];
    if (events != null) loaderFunc = (day) => _getEventsForDay(day, events);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TableCalendar(
        shouldFillViewport: true,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        eventLoader: loaderFunc,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.twoWeeks: 'Weeks',
          CalendarFormat.week: 'Day',
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
          log('Selected: $selectedDay;');
          setState(() {
            _selectedDay = selectedDay;
            _showDayView = true;
          });
          // context.replaceNamed(Strings.dayView, extra: selectedDay);
        },
        onFormatChanged: (format) {
          if (format == CalendarFormat.week) {
            // context.replaceNamed(Strings.dayView);
            setState(() {
              _showDayView = true;
            });
          } else {
            setState(() {
              _calendarFormat = format;
            });
          }
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
                  ],
                ),
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
                        style: defaultDaysStyle,
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
                          style: defaultDaysStyle.copyWith(color: theme.colorScheme.secondary),
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
                          style: defaultDaysStyle,
                        ),
                      ]
                  )
              ),
            );
          },

          // Marker for events below days
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 15,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}