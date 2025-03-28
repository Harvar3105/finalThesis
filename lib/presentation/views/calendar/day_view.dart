import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/helpers/calendar_parser.dart';
import '../../../configurations/strings.dart';

class DayViewCalendar extends StatefulWidget {
  const DayViewCalendar({super.key});

  @override
  DayViewCalendarState createState() => DayViewCalendarState();
}

class DayViewCalendarState extends State<DayViewCalendar> {
  DateTime _selectedDay = DateTime.now();

  final Map<DateTime, List<String>> events = {
    DateTime(2025, 3, 27, 9): ['Совещание с командой'],
    DateTime(2025, 3, 27, 11): ['Обед с партнером'],
    DateTime(2025, 3, 27, 14): ['Встреча с клиентом'],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TableCalendar(
          focusedDay: _selectedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: CalendarFormat.week,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
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
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
          onFormatChanged: (format) {
            //TODO: Redirect to proper page without animation
            context.goNamed(Strings.home, extra: {'disableAnimation': true});
          },
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (BuildContext context, DateTime day) {
              return Center(
                child: Text(
                  '${getMonthName(month: day.month)} | ${day.day}-th',
                  style: theme.textTheme.bodySmall,
                ),
              );
            },
            dowBuilder: (BuildContext context, DateTime day) {
              return Center(
                child: Text(
                  getWeekdayName(weekday: day.weekday, isShort: true).toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 15),
                ),
              );
            },
          ),
        ),


        const Divider(height: 1),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(
                    24,
                        (hour) => buildHourRow(hour, constraints.maxWidth),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Строит строку для указанного часа.
  /// В строке слева отображается время (фиксированная ширина 60),
  /// а справа – события, обёрнутые в горизонтально скроллируемый Row.
  Widget buildHourRow(int hour, double availableWidth) {
    // Выбираем события, относящиеся к выбранному дню и конкретному часу.
    final hourEvents = events.entries.where((entry) {
      final eventTime = entry.key;
      return eventTime.year == _selectedDay.year &&
          eventTime.month == _selectedDay.month &&
          eventTime.day == _selectedDay.day &&
          eventTime.hour == hour;
    }).toList();

    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Container(
            width: 60,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: hourEvents.map((entry) {
                  return Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Text(
                      entry.value.join(', '),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
