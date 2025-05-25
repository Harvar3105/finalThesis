import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:calendar_day_view/calendar_day_view.dart';

import '../../../app/typedefs/e_event_type.dart';
import '../../../configurations/strings.dart';
import '../../../data/domain/event.dart';
import '../../../data/domain/user.dart';
import '../../view_models/calendar/day_view_model.dart';


class DayViewCalendar extends ConsumerStatefulWidget {
  final DateTime? selectedDay;
  final VoidCallback changeView;
  final User? user;
  final bool isProfileView;
  const DayViewCalendar({super.key, this.selectedDay, required this.changeView, this.user, this.isProfileView = false});

  @override
  _DayViewCalendarState createState() => _DayViewCalendarState();
}

class _DayViewCalendarState extends ConsumerState<DayViewCalendar> {
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDay?.toLocal() ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = MediaQuery.sizeOf(context);

    Widget result;

    if (widget.isProfileView) {
      result = Scaffold(
        body: _buildCalendar(theme, size, widget.user),
      );
    } else {
      result = Scaffold(
        body: _buildCalendar(theme, size, widget.user),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? shouldRefresh = await context.pushNamed<bool>(Strings.addEvent);
            if (shouldRefresh ?? false) {
              ref.invalidate(dayViewModelProvider(user: widget.user));
            }
          },
          child: const Icon(Icons.add),
        ),
      );
    }
    return result;
  }

  Widget _buildCalendar(ThemeData theme, Size size, User? user) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: selectedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: CalendarFormat.week,
          selectedDayPredicate: (day) => isSameDay(day, selectedDay),
          onDaySelected: (sel, focusedDay) {
            setState(() {
              selectedDay = sel;
            });
          },
          headerStyle: HeaderStyle(
            formatButtonTextStyle: theme.textTheme.bodySmall!,
            formatButtonDecoration: BoxDecoration(
              border: Border.all(width: 1.0, color: theme.colorScheme.primary),
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(25.0),
            ),
            formatButtonShowsNext: false,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(25.0),
            ),
            headerPadding: const EdgeInsets.all(0),
            headerMargin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
          ),
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, day) {
              return Center(
                child: Text(
                  '${DateFormat.MMMM().format(day)} | ${day.day}-th',
                  style: theme.textTheme.bodySmall,
                ),
              );
            },
            dowBuilder: (context, day) {
              return Center(
                child: Text(
                  DateFormat.E().format(day).toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              );
            },
          ),
          onFormatChanged: (format) {
            widget.changeView();
          },
        ),
        const Divider(height: 5),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final eventsAsync = ref.watch(dayViewModelProvider(user: widget.user));
              final viewModel = ref.read(dayViewModelProvider(user: widget.user).notifier);
              return eventsAsync.when(
                data: (events) {
                  List<DayEvent<Event>> calendarEvents = events?.where((event) =>
                  event.start.year == selectedDay.year &&
                      event.start.month == selectedDay.month &&
                      event.start.day == selectedDay.day &&
                      event.end.year == selectedDay.year &&
                      event.end.month == selectedDay.month &&
                      event.end.day == selectedDay.day
                  ).map((e) {
                    return DayEvent<Event>(
                      start: e.start,
                      end: e.end,
                      value: e,
                    );
                  }).toList() ?? [];
                  log(calendarEvents.toString());
                  if (calendarEvents.isEmpty) {
                    return const Center(child: Text('No events'));
                  }

                  return CalendarDayView.overflow(
                    events: calendarEvents,
                    config: OverFlowDayViewConfig(
                      dividerColor: Colors.black,
                      currentDate: selectedDay,
                      timeGap: 60,
                      heightPerMin: 1.5,
                      endOfDay: const TimeOfDay(hour: 24, minute: 0),
                      startOfDay: const TimeOfDay(hour: 0, minute: 0),
                      showCurrentTimeLine: true,
                      showMoreOnRowButton: true,
                      time12: false,
                      renderRowAsListView: true,
                      timeLabelBuilder: (context, time) => Text(
                        '${time.hour}:${time.minute.toString().trim().length < 2 ?
                        '${time.minute}0' : time.minute.toString()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTimeTap: (t) {
                      log(t.toString());
                    },
                    overflowItemBuilder: (context, constraints, itemIndex, event) {
                      final overlap = viewModel.checkEventOverlap(event.value);
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        key: ValueKey(event.hashCode),
                        onTap: () async {
                          bool? shouldRefresh = await context.pushNamed(Strings.eventView, extra: [event.value, overlap]);
                          if (shouldRefresh ?? false) {
                            ref.invalidate(dayViewModelProvider(user: widget.user));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 3, left: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          key: ValueKey(event.hashCode),
                          width: size.width / 4 - 6,
                          height: constraints.maxHeight,
                          decoration: BoxDecoration(
                            color: overlap ?
                            Colors.red.shade500 :
                            switch (event.value.type) {
                              EEventType.declared => Colors.grey,
                              EEventType.shadow => Colors.blueGrey,
                              EEventType.accepted => Colors.green,
                              EEventType.canceled => Colors.red,
                              EEventType.conterOffered => Colors.amberAccent,
                              EEventType.processed => Colors.blueGrey.withAlpha(125),
                            },
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer
                            ),
                            child: Center(
                              child: Text(
                                event.value.title,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text(error.toString())),
              );
            },
          ),
        ),
      ],
    );
  }
}
