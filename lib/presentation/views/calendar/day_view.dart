import 'dart:developer';

import 'package:final_thesis_app/data/domain/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/helpers/calendar_parser.dart';
import '../../../configurations/strings.dart';
import '../../view_models/calendar/day_view_model.dart';
import '../widgets/animations/animation_with_text.dart';
import '../widgets/animations/error_animation.dart';
import '../widgets/animations/loading/loading_animation.dart';

class DayViewCalendar extends ConsumerStatefulWidget {
  final DateTime? selectedDay;
  const DayViewCalendar({super.key, this.selectedDay});

  @override
  DayViewCalendarState createState() => DayViewCalendarState();
}

class DayViewCalendarState extends ConsumerState<DayViewCalendar> {
  void onPressed(DateTime selectedDay) {
    context.pushNamed(Strings.addEvent, extra: selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedOrCurrentDay = widget.selectedDay ?? DateTime.now();
    final theme = Theme.of(context);
    final dayViewModel = ref.read(dayViewModelProvider);

    return dayViewModel.when(
        data: (events) {

          return Scaffold(
            body: Column(
              children: [
                TableCalendar(
                  focusedDay: selectedOrCurrentDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: CalendarFormat.week,
                  selectedDayPredicate: (day) => isSameDay(day, selectedOrCurrentDay),
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
                      selectedOrCurrentDay = selectedDay;
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
                                (hour) => buildHourRow(
                                    selectedOrCurrentDay, hour, constraints.maxWidth, events),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                onPressed(selectedOrCurrentDay);
              },
              tooltip: Strings.addEvent,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.add, size: 48,),
            ),
          );
        },
        loading: () => const AnimationWithText(
            animation: LoadingAnimationView(), text: 'Loading events...'),
      error: (error, stackTrace) {
        log('DayView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );

  }

  Widget buildHourRow(DateTime selectedDay, int hour, double availableWidth, List<Event> events) {
    final hourEvents = events.where((entry) {

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
